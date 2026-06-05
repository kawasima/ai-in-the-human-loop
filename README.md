# AI in the human loop

![A human at a laptop on the left and an AI agent on the right, with an open HUMAN.md notebook listing entries H-001, H-002, H-003 between them. A coral arrow loops from the AI back through the notebook to the human, showing that the AI writes feedback into HUMAN.md so the human can write better requests.](docs/images/hero.webp)

A template and live experiment for running a `HUMAN.md` feedback loop in coding
projects that use AI agents.

`HUMAN.md` collects friction that an agent observes on the human side of the
loop — unclear requests, missing decisions, undeclared scope, absent review
criteria — and turns each observation into a concrete prompt or review pattern
the human can use next time.

This repository is two things at once:

1. **A template** you can install to start the loop in another repository. The
   skill, the `/triage` command, the schema, and the SessionStart and Stop hooks
   are written to be domain-neutral and install once at user scope; a repository
   that opts in carries only its own `HUMAN.md`.
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
Observe   → an agent notices friction during work; the Stop hook nudges it at
            the end of each turn to record anything it observed
Record    → the human-feedback skill writes a structured entry to HUMAN.md
Surface   → the SessionStart hook puts open HUMAN.md entries in front of the
            human at the start of each session
Triage    → /triage moves entries from open to adopted, obsolete, or merged
```

Two Claude Code hooks drive the loop's edges. The **SessionStart hook**
(`scripts/session-start.sh`) surfaces open entries when a session begins. The
**Stop hook** (`scripts/stop-reminder.sh`) fires at the end of every turn and
emits one short, conditional reminder so the agent reconsiders, against the
skill's own bar, whether the turn produced friction worth recording. It never
blocks the turn; both hooks stay silent in repositories without a `HUMAN.md`.

The schema for an entry is defined in
[skills/human-feedback/HUMAN.schema.md](skills/human-feedback/HUMAN.schema.md).

## Getting started in another repository

Use [install.sh](install.sh). It has two steps — install everything the loop
needs once at user scope, then drop a `HUMAN.md` into each repository where you
want the loop. A repository that opts in carries a single file.

```sh
# 1. Install the loop for your agent at user scope.
#    Pick one (or run multiple times for multiple agents):
curl -fsSL https://raw.githubusercontent.com/kawasima/ai-in-the-human-loop/main/install.sh | bash -s claude
curl -fsSL https://raw.githubusercontent.com/kawasima/ai-in-the-human-loop/main/install.sh | bash -s codex
curl -fsSL https://raw.githubusercontent.com/kawasima/ai-in-the-human-loop/main/install.sh | bash -s gemini

# 2. In each repository where you want the loop, drop in HUMAN.md:
cd <your-repo>
bash ~/.ai-in-the-human-loop/repo/install.sh --init
```

What each step does:

- **Global install** (`install.sh <platform>`): symlinks
  `skills/human-feedback/` into your agent's user-scope skills directory
  (`~/.claude/skills/` for Claude Code, `~/.agents/skills/` for Codex and
  Gemini, which share the SKILL.md convention). The schema travels bundled
  inside the skill, so the skill reads it without the repository on disk. For
  Claude Code it also symlinks the `/triage` slash command into
  `~/.claude/commands/` and registers the SessionStart and Stop hooks in
  `~/.claude/settings.json` — a JSON-aware merge that leaves your existing
  hooks untouched and is idempotent on repeat runs. Gemini uses a TOML format
  incompatible with our command, and modern Codex prefers skills over prompts,
  so neither gets the command; the hooks are Claude-Code-specific.
- **`--init`**: copies a single `HUMAN.md` into the current directory. An
  existing `HUMAN.md` is never overwritten. Nothing else lands in the repo —
  the skill, command, schema, and hooks all live at user scope.

Both hooks resolve `./HUMAN.md` from the repository root. In a repository
without a `HUMAN.md` they print nothing and exit, so the global hooks are
harmless everywhere else.

After `--init`, empty out the sample entries in `HUMAN.md` (keep the headers and
the `Operation Log` section), then commit it.

If the target repository uses a documentation language other than English, the
`human-feedback` skill will match that language when it writes entries.

Other commands: `install.sh --update` pulls the latest changes (symlinks pick
them up automatically); `install.sh --uninstall <platform>` removes the links
for that platform, removes the SessionStart and Stop hooks for Claude Code, and leaves
the checkout for others.

## Scope of this repository

Phase 1 (the basic loop) and Phase 2 (surfacing and triage) are implemented
here. Phase 3 (CI checks, metrics snapshots, automated triage) is intentionally
deferred. See [docs/roadmap.md](docs/roadmap.md) for what is being held back
and why.

## Experiments

[examples/todo-app](examples/todo-app/) is a small stub project used as a
dogfooding target. The skill, command, schema, and hook come from the global
install; the example maintains its own `HUMAN.md` so the loop can be exercised
on a contained codebase without polluting this repository's own feedback log.
