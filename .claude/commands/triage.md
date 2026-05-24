---
description: Triage open HUMAN.md entries — move them to adopted, obsolete, or merged.
---

Walk through every entry under `## Open Feedback Items` in `HUMAN.md` one at a
time. For each entry:

1. Read the entry's `Observed`, `Better Human Action`, and any `Linked PRs`.

2. Decide its next status:
   - **adopted** if the improvement has shown up in real work. There must be
     at least one PR in `Linked PRs`, and the PR's body or diff must reflect
     the Prompt Pattern or Review Pattern. If `Linked PRs` is empty, the
     entry stays `open`.
   - **obsolete** if the precondition that caused the friction no longer
     holds (the code, workflow, or team has changed), or if the improvement
     was tried and turned out not to help. Add a one-line note explaining
     which.
   - **merged** if a more recent entry has absorbed this one, or if you find
     two open entries describing the same friction. Move the older entry to
     `Merged Items` with a pointer to the surviving entry's ID. Do not
     delete content.
   - **unchanged** if none of the above applies. Move on.

3. When you change an entry's status:
   - Update the `Status` field.
   - Move the entry to the matching section (`Adopted Items`, `Obsolete
     Items`, or `Merged Items`).
   - Append one line to `## Operation Log` at the bottom of `HUMAN.md`:
     `YYYY-MM-DD — H-NNN: open → adopted` (or similar). Include a short
     reason if the transition is not obvious.

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
