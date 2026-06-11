# HUMAN.md — Action Rules (rules layer)

The current, distilled rules for how to write requests, review work, and make
decisions next time. Few, abstracted, rewritten as they sharpen. The agent does
not update this file to assign blame; it converts friction into something you
can paste into the next request or check during the next review.

Raw observations (when and in what context each friction happened) live,
append-only, in [HUMAN_FRICTIONS.md](HUMAN_FRICTIONS.md). Each rule links to the
friction IDs that justify it.

Schema: [HUMAN.schema.md](HUMAN.schema.md). Loop overview: [README.md](README.md).

## How to run the loop in this repo (takes precedence over the skill)

When the human-feedback skill fires:

1. **Append the observation to HUMAN_FRICTIONS.md** (date, context, impact).
   Append-only — never rewrite a past observation.
2. **Update the rule here.** If the observation matches an existing rule, add the
   friction ID and sharpen the rule body (Prompt/Review Pattern). If it reveals a
   new generalization, write a new rule.
3. **When similar rules accumulate, abstract upward** into a single meta-rule and
   move the absorbed ones to Merged (instance → pattern → meta-rule). Keep the
   friction log; the meta-rule points at several friction IDs.
4. **Every rule carries a paste-ready Prompt Pattern or a runnable Review
   Pattern.** If you cannot write one, do not make a rule — leave it in the
   friction log only.

---

## Open Feedback Items

### H-001: Declare change scope before requesting implementation

- **Category**: scope
- **Status**: open
- **Friction log**: [HUMAN_FRICTIONS.md → H-001](HUMAN_FRICTIONS.md)
- **Linked PRs**: -

#### Better Human Action

Before requesting implementation, name the subsystems that may change and the
subsystems that must remain stable.

#### Prompt Pattern

```text
Change scope:
- API surface: allowed | forbidden | unknown
- DB schema:   allowed | forbidden | unknown
- UI:          allowed | forbidden | unknown
- Tests:       allowed | forbidden | unknown
- Docs:        allowed | forbidden | unknown

Compatibility requirements:
-
```

#### Review Pattern

While reviewing the diff, check that every changed file falls inside a
subsystem marked `allowed` in the original request. If a file outside the
declared scope was touched, ask why before approving.

---

### H-002: State the success criterion when the work is open-ended

- **Category**: spec
- **Status**: open
- **Friction log**: [HUMAN_FRICTIONS.md → H-002](HUMAN_FRICTIONS.md)
- **Linked PRs**: -

#### Better Human Action

When the work has no obvious completion test, state the success criterion
explicitly: a measurable property, a list of files, a behavior in production,
or "stop here regardless."

#### Prompt Pattern

```text
Done when:
- <observable condition 1>
- <observable condition 2>

Out of scope for this round:
- <thing the agent might pick up but should not>
```

#### Review Pattern

Before approving, check that the PR description names the condition the
human gave. If it does not, the PR was not actually answering the request.

---

## Adopted Items

No items yet. Entries move here from `Open` once `Linked PRs` shows the
improvement was used in real work.

---

## Obsolete Items

No items yet. Entries move here when the precondition no longer holds or the
improvement turned out not to help.

---

## Merged Items

No items yet. When similar rules are abstracted into one meta-rule, the absorbed
rules move here (the friction log in HUMAN_FRICTIONS.md is kept; the meta-rule
points at their H-IDs).
