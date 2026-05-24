# todo-app

A stub TypeScript CLI used as a dogfooding target for the `HUMAN.md` loop.

The code here is intentionally minimal — just enough surface that a request
to "improve" or "extend" it can be genuinely ambiguous about scope. The
point is not the todo app; the point is the friction that ambiguous requests
create.

## How to run the experiment

Throw requests at this directory and watch how the loop behaves. Requests
that work well for this experiment include:

- "Make the CLI better."
- "Add a feature to this todo app."
- "Clean up the code."
- "Improve the API."

For each request:

1. Note whether the agent surfaced any `HUMAN.md` entry from the parent
   repository before starting.
2. Note whether the agent asked clarifying questions before implementing.
3. Note whether the `human-feedback` skill ran, and what it recorded in
   `examples/todo-app/HUMAN.md`.
4. Append one line to `Operation Log` describing the request, what happened,
   and what was recorded.

## Relationship to the parent repository

This directory shares the parent's `AGENTS.md`, `skills/human-feedback/`,
and `.claude/` settings. The only files local to `todo-app` are:

- `src/`, `test/`, `package.json`, `tsconfig.json` — the codebase itself
- `HUMAN.md` — friction observed against this codebase specifically

The parent repository's `HUMAN.md` and this repository's `HUMAN.md` evolve
independently. An entry in one does not propagate to the other.

## Not actually built

There is no build step here on purpose. The TypeScript is for shape, not
execution. If a request happens to require running the code, that itself is
useful friction to observe.
