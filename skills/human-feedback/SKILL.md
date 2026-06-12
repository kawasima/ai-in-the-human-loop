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

When those hold, you log the observation in `HUMAN_FRICTIONS.md`. Whether it
also becomes a rule in `HUMAN.md` is a separate question, decided in the
procedure: a rule needs a concrete Prompt Pattern or Review Pattern, so an
observation that cannot yet be generalized stays in the log until it can. The
absence of a pattern is a reason to hold the rule, not to skip the skill.

Do **not** use this skill for:

- A one-off confusion that is unlikely to recur.
- Friction already covered by an existing `HUMAN_FRICTIONS.md` entry whose
  frequency and impact have not changed.
- Observations about the agent's own vocabulary or output style — those
  belong in Claude Code memory, not in this loop.
- Generic advice ("the human should be clearer") with no specific, nameable
  friction behind it.

## Two layers

The loop keeps two files, with two lifecycles:

- **`HUMAN_FRICTIONS.md` — the log layer.** Raw observations, append-only. Each
  is a dated record of when/in what context a friction happened and how it hit
  the work. The observation text is never rewritten; only the summary fields
  (`Last observed`, `Frequency`, `Impact`) move as the same friction recurs.
- **`HUMAN.md` — the rules layer.** The current, distilled action rules
  (`Better Human Action` + `Prompt Pattern` + `Review Pattern`). Rewritten and
  consolidated as they sharpen. Each rule links to its friction by `H-ID`.

A repository's own `HUMAN.md` may carry a "how to run the loop here" preamble
that takes precedence over this skill.

## Procedure

1. **Read both files.** Read `HUMAN.md` (the rules) and `HUMAN_FRICTIONS.md`
   (the log). You are checking whether this observation matches an existing
   friction/rule, and whether several rules now want to be merged upward.

2. **Append the observation to `HUMAN_FRICTIONS.md`.**
   - If it materially matches an existing friction, update that friction's `Last
     observed`, increment `Frequency`, revise `Impact` if it changed, and append
     a dated one-line note under `Observed` if the new instance reveals something
     the old one did not.
   - If it is new, append a new friction entry under the next unused `H-NNN` ID.
   - Append-only: never delete or rewrite a past observation.

3. **Update the rule in `HUMAN.md`.**
   - If a rule already covers this friction, add the friction `H-ID` to its
     `Friction log` line and sharpen the `Prompt Pattern` / `Review Pattern`.
   - If the generalization is new, write a new rule (same `H-ID` as the
     friction) with `Better Human Action` and at least one of `Prompt Pattern`
     or `Review Pattern`.
   - **Abstract upward when rules pile up:** if two or more rules describe the
     same underlying habit, merge them into one meta-rule, move the absorbed
     rules to `Merged`, and have the meta-rule cite every contributing friction
     `H-ID`. The log is never collapsed — only the rule side.

4. **Follow the schema** in `HUMAN.schema.md` (bundled next to this skill) for
   both the friction entry and the rule entry.

5. **Check the update threshold before saving.**
   - Is the Prompt Pattern paste-ready? A reader should be able to copy it
     into a request without editing it for the specific situation.
   - Is the Review Pattern runnable? A reviewer should be able to apply it as
     a yes/no check.
   - If neither can be written concretely, record the observation in
     `HUMAN_FRICTIONS.md` only and do **not** create a rule. Tell the user the
     observation was logged but did not clear the rule threshold.

6. **Tone.** Describe the friction, not the human's failure. Write about
   what happened to the work, not what the human did wrong.

   Avoid: "The user gave a vague instruction."
   Prefer: "The request did not declare which subsystems were in scope, so
   the agent chose the narrowest interpretation."

7. **Language.** Match the language already used in the existing `HUMAN.md` /
   `HUMAN_FRICTIONS.md`. If you are creating them for the first time in a fresh
   repository, match the language used in that repository's primary
   documentation (`README.md`).

## Output

The skill's output is the updated `HUMAN_FRICTIONS.md` (the observation) and,
when the threshold is met, the updated `HUMAN.md` (the rule). Do not produce a
separate report. The entries themselves are the artifact.

After the update, surface to the user:

- Which friction was logged and which rule was added or modified (with H-ID)
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
