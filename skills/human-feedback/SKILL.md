---
name: human-feedback
description: Use while or after development work when friction on the human side of the loop materially affected implementation, review, or design — an unclear request, a recurring ambiguity, a missing decision, undeclared scope, absent review criteria, a missing specification, or an unsafe assumption you were forced to make. Watch for these during work and convert the observation into a structured entry in HUMAN.md.
---

# Human Feedback Skill

## Purpose

Convert observed friction on the human side of the agent loop into an entry
that changes how the human writes requests, reviews work, or makes decisions
next time.

## When to use

Watch for these kinds of friction while working: the same ambiguity returning
across requests, an implementation that stalled because a human decision was
missing, rework caused by an unclear change scope, a review that missed
something because the criteria were not declared, specification intent that was
never written down, or a point where you had to make an unsafe assumption.

Invoke the skill when **all** of the following are true:

- The work just done was non-trivial.
- A specific moment of friction can be named, not just a vague feeling.
- The friction came from the human side (request, decision, review criteria,
  context, specification) — not from the agent's own behavior.
- A concrete Prompt Pattern or Review Pattern can be written for it.

Do **not** use this skill for:

- A one-off confusion that is unlikely to recur.
- Friction already covered by an existing `HUMAN.md` entry whose frequency
  and impact have not changed.
- Observations about the agent's own vocabulary or output style — those
  belong in Claude Code memory, not in `HUMAN.md`.
- Generic advice ("the human should be clearer"). If you cannot write a
  paste-ready Prompt Pattern or a runnable Review Pattern, do not add an
  entry.

## Procedure

1. **Read the current `HUMAN.md`.** Skim every open entry. You are checking
   for duplication and for entries whose frequency or impact this observation
   might bump.

2. **Decide: duplicate, update, or new.**
   - If the observation matches an open entry's `Observed` paragraph
     materially, update `Last observed`, increment `Frequency`, and revise
     `Impact` if it has changed. Add a one-line note under `Observed` if the
     new instance reveals something the old one did not.
   - If the observation is new, draft a new entry. Use the next unused
     `H-NNN` ID.

3. **Write the entry.** Follow the schema in `HUMAN.schema.md` (bundled next
   to this skill) exactly. All fields are required. The body must contain
   `Observed`, `Impact`, `Better Human Action`, and at least one of `Prompt
   Pattern` or `Review Pattern`.

4. **Check the update threshold before saving.**
   - Is the Prompt Pattern paste-ready? A reader should be able to copy it
     into a request without editing it for the specific situation.
   - Is the Review Pattern runnable? A reviewer should be able to apply it as
     a yes/no check.
   - If either is generic advice in disguise, do not save the entry. Tell the
     user what you observed and that it did not meet the threshold.

5. **Tone.** Describe the friction, not the human's failure. Write about
   what happened to the work, not what the human did wrong.

   Avoid: "The user gave a vague instruction."
   Prefer: "The request did not declare which subsystems were in scope, so
   the agent chose the narrowest interpretation."

6. **Language.** Match the language already used in the existing `HUMAN.md`.
   If you are creating `HUMAN.md` for the first time in a fresh repository,
   match the language used in that repository's primary documentation
   (`README.md`).

## Output

The skill's output is a modified `HUMAN.md` file. Do not produce a separate
report. The entry itself is the artifact.

After the update, surface to the user:

- Which entry was added or modified
- The Prompt Pattern or Review Pattern that resulted
- Any open question that prevented you from updating (if the threshold was
  not met)

## Anti-patterns to avoid

- **Filing every observation.** Most friction is one-off. Filing them all
  turns `HUMAN.md` into noise and trains readers to ignore it.
- **Vague Prompt Patterns.** "Be more specific about scope" is not a
  Prompt Pattern. A Prompt Pattern is a snippet the human can paste.
- **Recording agent issues as human issues.** If the fix is "the agent
  should remember X," the entry belongs in Claude Code memory, not in
  `HUMAN.md`.
- **Editorializing.** Do not add commentary about how the human "should
  have known" or "could have anticipated." Describe the friction and write
  the pattern.
