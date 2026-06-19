---
description: Record human-side friction from the recent work via the human-feedback skill.
---

Run the **Record** edge of the loop on demand. Use this when you want to capture
human-side friction deliberately, rather than relying on the per-turn Stop nudge
(and it is the entry point when this repository runs in explicit collection mode,
`HUMAN_LOOP_MODE=explicit`).

Look back over the recent work in this session and decide whether any human-side
friction materially affected it. Watch for the kinds the `human-feedback` skill
lists: the same ambiguity returning across requests, an implementation that
stalled because a human decision was missing, rework caused by an unclear change
scope, a review that missed something because the criteria were not declared,
specification intent that was never written down, or a point where you had to
make an unsafe assumption.

1. If a specific, nameable friction came from the human side and the work it
   affected was non-trivial, invoke the `human-feedback` skill to record it. The
   skill appends the observation to `HUMAN_FRICTIONS.md` and, only when it clears
   the threshold, writes or sharpens a rule in `HUMAN.md`. Follow the skill's own
   procedure and bar — do not lower it just because this command was run.

2. If there was no such friction, say so in one line and stop. Do not file an
   entry to have something to show; most turns have nothing worth recording.

Do not triage existing rules here — that is `/triage`. This command only records
new observations.
