# HUMAN.schema.md

Schema for the two-layer loop. The `human-feedback` skill produces entries that
follow this schema.

- **`HUMAN_FRICTIONS.md` — log layer.** Raw observations, append-only.
- **`HUMAN.md` — rules layer.** Distilled, current action rules. Rewritten and
  consolidated. Each rule links to its friction by `H-ID`.

This copy is bundled with the skill so the globally-installed skill can read it
without the upstream repository on disk. The repository root keeps a copy at
`../../HUMAN.schema.md`. Only this intro note differs between the two; the schema
itself is kept in sync, so when you change the schema, change both.

## Friction entry (HUMAN_FRICTIONS.md)

```markdown
### H-NNN: <short headline>

- **Category**: prompt | scope | context | decision | review | spec | test | docs
- **First observed**: YYYY-MM-DD
- **Last observed**: YYYY-MM-DD
- **Frequency**: <integer>
- **Impact**: low | medium | high

#### Observed
What happened. Concrete, with enough detail that a reader who was not present
can recognize the situation. New instances of the same friction append a dated
one-line note here; past text is not rewritten.

#### Impact
How the friction affected implementation, review, or design. Not "this was
bad" — what changed, what was skipped, what risk was taken on.
```

## Rule entry (HUMAN.md)

```markdown
### H-NNN: <short headline>

- **Category**: prompt | scope | context | decision | review | spec | test | docs
- **Status**: open | adopted | obsolete | merged
- **Friction log**: [HUMAN_FRICTIONS.md → H-NNN](HUMAN_FRICTIONS.md)  (one or more H-IDs)
- **Linked PRs**: <PR URLs, or `-`>

#### Better Human Action
What a human should do differently next time. Specific behavior, not advice.

#### Prompt Pattern
A snippet a human can paste into a request to prevent this friction. Optional
if a Review Pattern is provided.

#### Review Pattern
A check a human can run during review to catch this friction. Optional if a
Prompt Pattern is provided.
```

At least one of `Prompt Pattern` or `Review Pattern` must be present in a rule.
If neither can be written concretely, the observation stays in
`HUMAN_FRICTIONS.md` only and **no rule** is created.

## ID format

`H-001`, `H-002`, `H-003`, ... Three-digit zero-padded, sequential. A friction
and its rule share the same `H-ID`. IDs are never reused. If a rule is obsoleted
or merged, the ID stays with the obsolete or merged record; the next new entry
takes the next unused number.

## Abstraction (the point of two layers)

The log accumulates instances; the rule side stays small. When two or more rules
describe the same underlying habit, abstract them into one **meta-rule**: write
the general rule, move the absorbed rules to `Merged`, and have the meta-rule's
`Friction log` cite every contributing `H-ID`. The friction log is never
collapsed — only the rule side is consolidated (instance → pattern → meta-rule).

## Status transitions (rules)

```
open ─────────────────────────────► adopted
  │                                    │
  │                                    ▼
  └─► obsolete                       obsolete
  │
  └─► merged (absorbed into a meta-rule)
```

- `open`: the rule exists; the improvement has not yet shown up in real work.
- `adopted`: there is concrete evidence the improvement was used. `Linked PRs`
  must be non-empty.
- `obsolete`: the precondition that caused the friction no longer holds, or the
  improvement turned out not to help.
- `merged`: the rule was absorbed into a meta-rule. The friction stays in the
  log; the meta-rule cites its `H-ID`.

Rules are not deleted. Obsolete and merged rules stay in `HUMAN.md` under their
own sections so the history of what did not work is preserved.

## Category vocabulary

| Category | What the human should improve |
|---|---|
| `prompt` | The wording of the request |
| `scope` | Which subsystems are declared in scope |
| `context` | Background, design intent, existing constraints |
| `decision` | A judgment the human has not yet made |
| `review` | Review criteria, what to check |
| `spec` | Requirements, invariants, acceptance criteria |
| `test` | Expected outcomes, test strategy |
| `docs` | Ownership of documentation updates |

If an observation does not fit any category, prefer the closest one over
inventing a new label. New labels should be discussed before being added.

## Update threshold

Log an observation, and add or update a rule, only when **all** of the following
hold:

- The friction was observed in real work, not predicted in theory
- For a rule: a Prompt Pattern or Review Pattern can be written concretely
- Either the observation is new, or an existing friction's frequency or impact
  changed in a way worth recording

The cost of a rule that no one reads is higher than the cost of an observation
that goes unrecorded — but a logged observation that cannot yet become a rule is
fine: it waits in the log until a pattern is clear enough to abstract.
