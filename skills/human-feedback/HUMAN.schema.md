# HUMAN.schema.md

Schema for entries in `HUMAN.md`. The `human-feedback` skill produces entries
that follow this schema.

This copy is bundled with the skill so the globally-installed skill can read it
without the upstream repository on disk. The repository root keeps an identical
copy at `../../HUMAN.schema.md`; the two are kept in sync. When editing the
schema, change both.

## Entry format

```markdown
### H-NNN: <short headline>

- **Status**: open | adopted | obsolete | merged
- **Category**: prompt | scope | context | decision | review | spec | test | docs
- **First observed**: YYYY-MM-DD
- **Last observed**: YYYY-MM-DD
- **Frequency**: <integer>
- **Impact**: low | medium | high
- **Linked PRs**: <PR URLs, or `-`>
- **Linked Memory**: <memory file names, or `-`>

#### Observed
What happened. Concrete, with enough detail that a reader who was not present
can recognize the situation.

#### Impact
How the friction affected implementation, review, or design. Not "this was
bad" — what changed, what was skipped, what risk was taken on.

#### Better Human Action
What a human should do differently next time. Specific behavior, not advice.

#### Prompt Pattern
A snippet a human can paste into a request to prevent this friction. Optional
if a Review Pattern is provided.

#### Review Pattern
A check a human can run during review to catch this friction. Optional if a
Prompt Pattern is provided.
```

At least one of `Prompt Pattern` or `Review Pattern` must be present. If
neither can be written concretely, the observation does not get an entry.

## ID format

`H-001`, `H-002`, `H-003`, ... Three-digit zero-padded, sequential. Never
reused. If an entry is obsoleted or merged, the ID stays with the obsolete or
merged record; the next new entry takes the next unused number.

## Status transitions

```
open ─────────────────────────────► adopted
  │                                    │
  │                                    ▼
  └─► obsolete                       obsolete
  │
  └─► merged (into another open entry)
```

- `open`: observed at least once. The improvement has not yet shown up in real
  work.
- `adopted`: there is concrete evidence the improvement was used. `Linked PRs`
  must be non-empty.
- `obsolete`: the precondition that caused the friction no longer holds, or
  the improvement turned out not to help.
- `merged`: the entry is a duplicate of, or has been absorbed into, another
  entry. Record the target ID under `Linked Memory` or in the body.

Entries are not deleted. Obsolete and merged entries stay in `HUMAN.md` under
their own sections so the history of what did not work is preserved.

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

Add or update an entry only when **all** of the following hold:

- The friction was observed in real work, not predicted in theory
- A Prompt Pattern or Review Pattern can be written concretely
- Either the observation is new, or an existing entry's frequency or impact
  changed in a way worth recording

The cost of an entry that no one reads is higher than the cost of an
observation that goes unrecorded.
