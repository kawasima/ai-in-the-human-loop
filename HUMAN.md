# HUMAN.md

Friction observed on the human side of the agent loop, structured into items
that change how requests, reviews, and decisions are made next time.

Schema: [HUMAN.schema.md](HUMAN.schema.md).
Loop overview: [README.md](README.md).

When you read this file, you are looking at improvements that the agent has
suggested for your own request, review, and decision behavior. The agent does
not update this file to assign blame; it updates it to convert friction into
something you can paste into the next request or check during the next
review.

---

## Open Feedback Items

### H-001: Declare change scope before requesting implementation

- **Status**: open
- **Category**: scope
- **First observed**: 2026-05-24
- **Last observed**: 2026-05-24
- **Frequency**: 1
- **Impact**: medium
- **Linked PRs**: -
- **Linked Memory**: -

#### Observed

A request to implement a change did not say whether the API surface, database
schema, UI, tests, or documentation were inside the change set. The agent
chose the narrowest interpretation and left related updates untouched.

#### Impact

The implementation landed inside the agent's chosen boundary but left
adjacent code in an inconsistent state. The follow-up needed a second round
of work to reconcile.

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

- **Status**: open
- **Category**: spec
- **First observed**: 2026-05-24
- **Last observed**: 2026-05-24
- **Frequency**: 1
- **Impact**: medium
- **Linked PRs**: -
- **Linked Memory**: -

#### Observed

A request asked the agent to "improve" or "clean up" an area without naming a
condition under which the work would be done. The agent stopped at a point
that felt reasonable but was not the human's stopping point.

#### Impact

The agent over-shot in some places (refactors the human did not want) and
under-shot in others (left work the human expected to be included). Review
time went to renegotiating the boundary rather than judging the result.

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

No items yet. Entries move here when they are absorbed into another entry.

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
