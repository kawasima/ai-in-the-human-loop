#!/usr/bin/env bash
# Nudge the agent, once per turn, to record human-side friction it observed.
#
# This runs on the Stop hook (after the main agent finishes a turn). It emits a
# single short, conditional reminder as additionalContext and exits 0. The agent
# then reflects, against the human-feedback skill's own high bar, on whether the
# turn's friction is worth an entry. The script makes no judgment of its own
# about whether friction occurred.
#
# The reminder is emitted with suppressOutput so its raw text is not shown in the
# transcript, and it tells the agent to end the follow-up turn with no output
# when there was no friction. The agent still receives the additionalContext (the
# nudge keeps working); only the visible noise of a no-friction turn is removed.
#
# Why the stop_hook_active guard matters: emitting additionalContext from a Stop
# hook makes the host re-invoke the agent for another turn. That turn also ends,
# firing this hook again — so without a guard the reminder re-injects forever and
# the turn never ends (the host eventually caps it as a runaway hook). The host
# sets stop_hook_active: true on the input whenever the Stop fired as a result of
# a previous Stop's continuation. We read that flag and stay silent when it is
# set, so the reminder is injected exactly once and the follow-up turn can end.
#
# Installed globally and wired into a Stop hook in ~/.claude/settings.json, so it
# runs for every repository. It looks for a HUMAN.md in the current working
# directory and stays silent when there is none, which makes it harmless in repos
# that do not use the loop. The reminder is one self-contained line, so it reads
# correctly whether the host surfaces Stop output as injected next-turn context
# or as plain hook output.

set -euo pipefail

HUMAN_MD="./HUMAN.md"

if [[ ! -f "$HUMAN_MD" ]]; then
  exit 0
fi

# Read the hook input from stdin and bail out while a Stop-triggered turn is
# already in flight, so the reminder cannot loop. The read is best-effort: if no
# input arrives we treat stop_hook_active as false and fall through to emit once.
INPUT="$(cat 2>/dev/null || true)"

if command -v jq >/dev/null 2>&1; then
  if [[ "$(printf '%s' "$INPUT" | jq -r '.stop_hook_active // false' 2>/dev/null)" == "true" ]]; then
    exit 0
  fi
else
  # Fallback without jq: match the flag in the raw JSON, tolerating any
  # whitespace (spaces, tabs, newlines) around the colon.
  if [[ "$INPUT" =~ \"stop_hook_active\"[[:space:]]*:[[:space:]]*true ]]; then
    exit 0
  fi
fi

REMINDER='[human-loop] If this turn involved non-obvious human-side friction (an unclear request, an undecided judgment, a misread assumption, a repeated question), consider recording it in HUMAN.md via the human-feedback skill. If there was none, end this turn immediately with no output or commentary.'

# suppressOutput hides this hook's stdout from the transcript, so the raw
# "[human-loop] ..." line is not shown to the user; the agent still receives the
# additionalContext and does its one follow-up turn. Paired with the reminder's
# "end immediately with no output" instruction, a no-friction turn stays quiet.
if command -v jq >/dev/null 2>&1; then
  jq -cn --arg ctx "$REMINDER" \
    '{suppressOutput: true, hookSpecificOutput: {hookEventName: "Stop", additionalContext: $ctx}}'
else
  # Fallback without jq: the reminder is a fixed string with no embedded quotes
  # or backslashes, so emitting it inside this JSON punctuation by hand is safe.
  printf '{"suppressOutput":true,"hookSpecificOutput":{"hookEventName":"Stop","additionalContext":"%s"}}\n' "$REMINDER"
fi

exit 0
