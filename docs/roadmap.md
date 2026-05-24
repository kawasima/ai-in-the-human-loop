# Roadmap

What is intentionally not in the repository yet, and the condition under
which each item gets added.

The principle: an item is added only when running the existing loop on real
work has shown a need for it. Adding mechanisms before they earn their place
is the failure mode this whole template is built against.

## Phase 3 candidates (deferred)

### CI check for `HUMAN.md` update misses

A script that runs on pull requests and looks for signals that an entry
might be warranted but was not written: phrases like "scope was unclear" or
"I had to assume" appearing in the PR body or review comments, repeated
churn on the same file, and so on. The script would post a comment, not
fail the build.

**Add when:** the manual loop has produced at least 10 entries across
adopted, obsolete, and merged combined, and at least one entry was missed
that a reviewer flagged after the fact.

### Metrics snapshot

A monthly file under `docs/metrics/snapshot-YYYY-MM-DD.md` recording:

- Total open / adopted / obsolete / merged counts
- New entries this month
- Rate at which open entries reached adopted
- Categories that grew the most

**Add when:** there is at least three months of operation history and a
specific question about the loop's health that the counts would answer.

### Automated triage assistance

A script that finds open entries with no `Linked PRs` for over N days and
suggests them as candidates for the next triage session.

**Add when:** triage has been run at least three times and the list of open
entries has grown large enough that walking through it by hand is taking
noticeable time.

### `examples/` directory — added early on 2026-05-24

Originally listed here with the condition "the template has been imported
into at least one other repository." That condition was not met. The
directory was added anyway because there was no other way to exercise the
loop against a contained codebase without waiting for an external import to
happen.

What is in place: `examples/todo-app/` — a TypeScript stub with its own
`HUMAN.md`, sharing the parent's `AGENTS.md`, `skills/`, and `.claude/`
settings.

What is not covered: the import process itself (copying files into a
genuinely separate repository) is still future work. When that happens,
the README's "Getting started in another repository" section should be
revised based on what the import actually needs.

## Items considered and rejected

### Auto-generating entries from PR descriptions

Tempting because PR descriptions are where friction often shows. Rejected
because the agent already does this through the `human-feedback` skill at
the right granularity. An automated pipeline would lower the per-entry
quality and produce noise.

### A web UI for browsing `HUMAN.md`

The point of `HUMAN.md` is that it lives next to the code and is read at the
moment the human is acting on the code. A separate UI takes it out of that
flow.

## Review cadence

This file is reviewed when triage runs. If a deferred item's "add when"
condition has been met, the work is moved into a feature branch.
