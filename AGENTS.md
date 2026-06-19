# AGENTS.md

Instructions for coding agents working in this repository.

## What this repository is

This is both a template for the `HUMAN.md` feedback loop and a live experiment
running that loop on itself. See [README.md](README.md) for the broader
context.

When you are working in this repository, you are doing two jobs at once:

1. Maintaining the template files so they remain useful in other repositories.
2. Updating this repository's own `HUMAN.md` based on what you observe while
   working here.

## HUMAN.md feedback loop

While working, watch for the following kinds of friction:

- The same ambiguity returning across requests
- An implementation that stalled because a human decision was missing
- Rework caused by an unclear change scope
- A review that missed something because the review criteria were not declared
- Specification intent that was not written down
- A situation where you had to make an unsafe assumption

When one of these materially affected the work, invoke the `human-feedback`
skill (see `skills/human-feedback/SKILL.md`). The loop keeps two files: the
skill appends the raw observation to `HUMAN_FRICTIONS.md` (the log layer, append-
only) and, when it clears the threshold, writes or sharpens a rule in `HUMAN.md`
(the rules layer). Each rule links to its friction by `H-ID`; when similar rules
pile up, abstract them into one meta-rule.

Do not add a rule to `HUMAN.md` when:

- The confusion was a one-off and will not recur
- An existing entry already covers it and neither frequency nor impact changed
- You cannot write a concrete Prompt Pattern or Review Pattern for it

`HUMAN.md` is not a place to record human mistakes. It is a place to convert
observed friction into prompts, review checks, and decisions that improve the
next round.

## How the loop is distributed

The same source tree ships two ways; keep both working when you move files.

- **Claude Code plugin.** `.claude-plugin/plugin.json` declares the plugin and
  its SessionStart + Stop hooks (pointing at `scripts/*.sh` through
  `${CLAUDE_PLUGIN_ROOT}`); `.claude-plugin/marketplace.json` lists this repo as
  a one-plugin marketplace (`source: "./"`). Claude Code auto-discovers `skills/`
  and `commands/` at the repo root, so the skill and the commands must stay at
  `skills/human-feedback/` and `commands/*.md`. The plugin auto-discovers every
  command in `commands/`, so `commands/init.md` (the per-repo scaffolder, the
  plugin's `install.sh --init` equivalent) is exposed without any manifest entry.
- **install.sh.** Symlinks `skills/human-feedback/` and the commands in
  `COMMAND_NAMES` (`triage.md`, `feedback.md`) into user-scope directories and
  registers the hooks in `settings.json`. It is the only route for Codex and
  Gemini. It does not link `init.md` — install.sh users scaffold per-repo files
  with `install.sh --init` instead.

A machine should use one route, not both — the hooks are additive, so two
installs make them fire twice. If you move the skill, the commands, or the
scripts, update both `.claude-plugin/plugin.json` and `install.sh`.

Observe has two modes per repository. By default the Stop hook nudges every turn
(auto). A repo opts into explicit collection by setting
`HUMAN_LOOP_MODE=explicit` in its `.claude/settings.json` `env`; the Stop hook
reads that env var — falling back to parsing the settings files with `jq`, since
it is unverified whether plugin-contributed hooks inherit project `env` — and
stays silent, leaving the user to record friction with `/feedback`. The Stop
hook is Claude-Code-only on both routes, so this toggle is a Claude Code
concern.

## Language

Write all template files in this repository in English: `README.md`,
`AGENTS.md`, `HUMAN.md`, `HUMAN_FRICTIONS.md`, `HUMAN.schema.md`,
`skills/human-feedback/SKILL.md`, the GitHub templates, and the Claude Code
command files.

When this template is copied into another repository, the `human-feedback`
skill matches the language already used in that repository's `HUMAN.md`. If it
is creating `HUMAN.md` fresh, it follows the repository's existing
documentation language.

## Writing style

- Avoid grand metaphors. Do not write phrases like "feedback loop machinery"
  or "the central nervous system of the loop."
- Do not start paragraphs with "**Keyword**: explanation" templates. Write
  prose.
- State a conclusion once. Do not restate it at the end of every section.
- Prefer active verbs ("Observe / Record / Surface / Triage") over
  nominalized constructs ("the observation phase / the recording mechanism").
- Bold sparingly. If a paragraph contains several bold spans, the prose is
  doing too little work.

## PR workflow

This repository targets `master` directly while it is bootstrapping. Once the
template is stable, switch to a `feature/* → develop` workflow.
