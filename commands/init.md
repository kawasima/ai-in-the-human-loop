---
description: Scaffold HUMAN.md (rules layer) and HUMAN_FRICTIONS.md (log layer) into this repository — the plugin route's equivalent of `install.sh --init`.
---

Drop the two starter files the loop needs into the **root of the current
repository**: `HUMAN.md` (the rules layer) and `HUMAN_FRICTIONS.md` (the log
layer). The skill, the schema, and the hooks already come from the plugin, so a
repository that opts into the loop carries only these two files.

For each file:

- If a file with that name **already exists** at the repo root, do not touch it.
  It is user-edited, and overwriting it would lose work. Report that you skipped
  it and stop touching that file.
- If it does not exist, create it with exactly the content given below — the
  headers and the section scaffolding, with no sample entries.

When both files are in place (or already existed), tell the user to commit them,
and that the `human-feedback` skill will populate them as friction is observed.

## `HUMAN.md`

```markdown
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

No items yet. The human-feedback skill adds rules here as friction is observed.

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
```

## `HUMAN_FRICTIONS.md`

```markdown
# HUMAN_FRICTIONS.md — Observation Log (log layer)

Raw friction observed on the human side of the agent loop, appended over time.
Never rewritten — this is the evidence trail of when, in what context, and to
what effect each friction occurred.

The distilled, current action rules live in [HUMAN.md](HUMAN.md). Each
observation links to its rule by H-ID. When similar observations accumulate,
the log is kept as-is and the rule side is abstracted into one meta-rule.

Schema: [HUMAN.schema.md](HUMAN.schema.md).

---

## Frictions

No observations yet. The human-feedback skill appends them here as friction is
observed.

---

## Operation Log

Notes from running the loop on this repository itself. Append-only, newest
last. Each entry: date, what happened, what changed in the template.
```
