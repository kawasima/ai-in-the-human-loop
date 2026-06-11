---
description: Triage open HUMAN.md entries — move them to adopted, obsolete, or merged.
---

The loop keeps two files: `HUMAN.md` (rules layer — the action rules) and
`HUMAN_FRICTIONS.md` (log layer — raw observations, append-only). Triage works on
the rules in `HUMAN.md`; it reads the log for context but never rewrites it.

Walk through every rule under `## Open Feedback Items` in `HUMAN.md` one at a
time. For each rule:

1. Read the rule's `Better Human Action`, its `Friction log` (the observations it
   cites in `HUMAN_FRICTIONS.md`), and any `Linked PRs`.

2. Decide its next status:
   - **adopted** if the improvement has shown up in real work. There must be
     at least one PR in `Linked PRs`, and the PR's body or diff must reflect
     the Prompt Pattern or Review Pattern. If `Linked PRs` is empty, the
     rule stays `open`.
   - **obsolete** if the precondition that caused the friction no longer
     holds (the code, workflow, or team has changed), or if the improvement
     was tried and turned out not to help. Add a one-line note explaining
     which.
   - **merged** if two or more open rules describe the same underlying habit.
     Abstract them into one **meta-rule**: write the general rule, move the
     absorbed rules to `Merged Items` with a pointer to the survivor's ID, and
     have the meta-rule's `Friction log` cite every contributing `H-ID`. Do not
     delete content, and never collapse the friction log — only the rule side.
   - **unchanged** if none of the above applies. Move on.

3. When you change a rule's status:
   - Update the `Status` field.
   - Move the rule to the matching section (`Adopted Items`, `Obsolete
     Items`, or `Merged Items`).
   - Append one line to `## Operation Log` at the bottom of
     `HUMAN_FRICTIONS.md`: `YYYY-MM-DD — H-NNN: open → adopted` (or similar).
     Include a short reason if the transition is not obvious.

4. After processing every open entry, also re-read the `Adopted Items`
   section. If an adopted entry has not been referenced in any new work for
   a long stretch and the underlying behavior change appears stable, you may
   move it to `Obsolete Items` with the note "behavior change is now
   habitual." This is a judgment call; when in doubt, leave it adopted.

Do not invent new entries during triage. If you observe new friction while
reading old entries, that is a job for the `human-feedback` skill in a
separate session.

When the walk is complete, summarize:

- How many entries were moved, by transition.
- Any open entries that have grown stale (no `Linked PRs` for many weeks)
  and might be candidates for obsoletion next round.
- Any pattern in the moved entries — for example, three entries in the
  `scope` category all moved to adopted at once may mean the human has
  internalized scope declaration.
