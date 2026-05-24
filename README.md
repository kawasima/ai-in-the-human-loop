# human-improving-the-loop

A template and live experiment for running a `HUMAN.md` feedback loop in coding
projects that use AI agents.

`HUMAN.md` collects friction that an agent observes on the human side of the
loop — unclear requests, missing decisions, undeclared scope, absent review
criteria — and turns each observation into a concrete prompt or review pattern
the human can use next time.

This repository is two things at once:

1. **A template** you can copy into another repository to start the loop. The
   files in this repository (`AGENTS.md`, `HUMAN.schema.md`,
   `skills/human-feedback/SKILL.md`, the GitHub templates, the Claude Code
   settings) are written to be domain-neutral so they transfer directly.
2. **A live experiment.** This repository runs its own `HUMAN.md` loop, and the
   `Operation Log` section at the bottom of `HUMAN.md` records what worked and
   what did not.

## How `HUMAN.md` differs from Claude Code memory

Claude Code already has a per-project memory system that records facts the
agent should remember across sessions. `HUMAN.md` is not a replacement for it.
They have different jobs.

| Observation | Where it goes |
|---|---|
| Something the agent itself should do differently (vocabulary, output format, procedure) | Claude Code memory |
| Something a human should write, review, or decide differently | `HUMAN.md` |

Examples:

- "Avoid the verb *tateru* on abstract nouns" → memory. The agent's wording is
  the thing being corrected.
- "Declare in the request which subsystems are in scope" → `HUMAN.md`. The
  human's request is the thing being corrected.

If an observation could belong to either side, write it in the place that
matches the corrective action, not the place that matches who made the mistake.

## The loop

```
Observe   → an agent notices friction during work
Record    → the human-feedback skill writes a structured entry to HUMAN.md
Surface   → SessionStart hook, PR template, and issue templates put HUMAN.md
            entries in front of the human at the moments they act
Triage    → /triage moves entries from open to adopted, obsolete, or merged
```

The schema for an entry is defined in [HUMAN.schema.md](HUMAN.schema.md).

## Getting started in another repository

1. Copy `AGENTS.md`, `HUMAN.md`, `HUMAN.schema.md`, the `skills/` directory,
   the `.claude/` directory, and the `.github/` directory into the target
   repository.
2. Empty out the sample entries in `HUMAN.md`. Keep the headers and the
   `Operation Log` section.
3. If the target repository uses a documentation language other than English,
   the `human-feedback` skill will match that language when it writes entries.
4. Open a pull request with the imported files so contributors see the
   `Human feedback loop` section of the PR template at least once.

## Scope of this repository

Phase 1 (the basic loop) and Phase 2 (surfacing and triage) are implemented
here. Phase 3 (CI checks, metrics snapshots, automated triage) is intentionally
deferred. See [docs/roadmap.md](docs/roadmap.md) for what is being held back
and why.
