#!/usr/bin/env bash
# Nudge the agent, once per turn, to record human-side friction it observed.
#
# This runs on the Stop hook (after the main agent finishes a turn). It emits a
# single short, conditional reminder as additionalContext and exits 0 — it never
# blocks, so it does not force the agent to continue and creates no loop risk.
# The agent sees the reminder on its next turn and decides, against the
# human-feedback skill's own high bar, whether the turn's friction is worth an
# entry. The script makes no judgment of its own about whether friction occurred.
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

REMINDER='[human-loop] このターンに非自明な人間側の摩擦（曖昧な要求・未決の判断・取り違えた前提・繰り返した質問）があったなら、human-feedback skill で HUMAN.md に記録するか検討せよ。無ければ何もしないでよい。'

if command -v jq >/dev/null 2>&1; then
  jq -cn --arg ctx "$REMINDER" \
    '{hookSpecificOutput: {hookEventName: "Stop", additionalContext: $ctx}}'
else
  # Fallback without jq: the reminder is plain ASCII-safe JSON punctuation around
  # a fixed string with no embedded quotes or backslashes, so manual emission is safe.
  printf '{"hookSpecificOutput":{"hookEventName":"Stop","additionalContext":"%s"}}\n' "$REMINDER"
fi

exit 0
