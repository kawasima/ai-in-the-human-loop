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

### H-001: Declare change scope before requesting implementation

- **Category**: scope
- **First observed**: 2026-05-24
- **Last observed**: 2026-05-24
- **Frequency**: 1
- **Impact**: medium

#### Observed

A request to implement a change did not say whether the API surface, database
schema, UI, tests, or documentation were inside the change set. The agent
chose the narrowest interpretation and left related updates untouched.

#### Impact

The implementation landed inside the agent's chosen boundary but left
adjacent code in an inconsistent state. The follow-up needed a second round
of work to reconcile.

### H-002: State the success criterion when the work is open-ended

- **Category**: spec
- **First observed**: 2026-05-24
- **Last observed**: 2026-05-24
- **Frequency**: 1
- **Impact**: medium

#### Observed

A request asked the agent to "improve" or "clean up" an area without naming a
condition under which the work would be done. The agent stopped at a point
that felt reasonable but was not the human's stopping point.

#### Impact

The agent over-shot in some places (refactors the human did not want) and
under-shot in others (left work the human expected to be included). Review
time went to renegotiating the boundary rather than judging the result.

---

## Operation Log

Notes from running the loop on this repository itself. Append-only, newest
last. Each entry: date, what happened, what changed in the template.

### 2026-05-24 — Bootstrap

Repository created. The two open items above (`H-001`, `H-002`) are seeded
from friction observed during the brainstorming session that produced this
template — they are not predictions, they are observations of how this very
project's initial request was framed.

### 2026-05-24 — examples/todo-app added ahead of schedule

The `examples/` directory was originally a Phase 3 deferred item with the
"add when" condition of "imported into at least one other repository." That
condition has not been met. The directory was added anyway, so the loop
could be exercised on a contained codebase without waiting for an external
import to happen. The roadmap entry has been updated to reflect this.

The trade-off accepted: `examples/todo-app` is not actually a separate
repository, so it does not test the import process. It only tests whether
the loop produces useful entries when run against a small unrelated
codebase. The import-process test remains future work.

### 2026-05-24 — markdownlint vs. entry schema

The first observation while editing `HUMAN.md` itself: the schema requires
`#### Observed`, `#### Impact`, `#### Better Human Action`, `#### Prompt
Pattern`, `#### Review Pattern` to repeat under every `### H-NNN` entry.
Markdownlint's default MD024 (no duplicate headings) flags this as a
problem.

This is not a human-side friction; it is a tooling-side friction caused by
the template itself. Resolution: added `.markdownlint.json` with
`MD024.siblings_only: true` so duplicate H4s are allowed when they live
under different H3 parents. Also disabled MD013 (line length) since wrapped
entry bodies will trip it.

Implication for the template: when this is copied into another repository
that already has a stricter markdownlint config, the new owner will need
to make the same allowance. This is worth mentioning in the README's
"Getting started" section if it comes up a second time.

### 2026-06-05 — Stop hook added to strengthen Observe

Running the loop on a real, multi-day coding session surfaced a gap: the
`Observe` edge had no mechanism. The SessionStart hook only surfaces existing
entries at session start, and the agent reached for the `human-feedback` skill
only at hard blocks. Softer, recurring friction (a bug report that named a
symptom but not the observable that localizes it, sending the agent to the
wrong layer several times) went unrecorded until a human flagged it afterward.

Resolution: added `scripts/stop-reminder.sh`, registered as a Claude Code
`Stop` hook by `install.sh`. It fires at the end of every turn and emits one
short, conditional reminder as `additionalContext`, never blocking. The script
makes no judgment about whether friction occurred; the reminder's brevity and
the skill's own bar do the filtering. `install.sh`'s hook register/unregister
was generalized to take an event name so SessionStart and Stop share one
idempotent jq merge.

Why a Stop hook rather than the Phase 3 "CI check for update misses": the CI
check is a heavier, PR-time static detector whose add-condition (at least 10
entries plus a reviewer-flagged miss) is not met. The Stop hook addresses the
same miss at its source — the moment of observation — with far less machinery,
which fits the template's "smallest mechanism that earns its place" principle.
The roadmap's CI-check item stays deferred.

### 2026-06-11 — Split into two layers

HUMAN.md was split into a rules layer (HUMAN.md — the current, abstracted
action rules) and a log layer (this file — raw observations, append-only).
Each rule links to its friction by H-ID. The goal: when similar frictions
accumulate, abstract the rule side up into one meta-rule rather than letting
parallel entries pile up (instance → pattern → meta-rule). `--init` now drops
both files; the skill and schema were updated to the two-layer flow. No
backward compatibility with the single-file layout is kept.
