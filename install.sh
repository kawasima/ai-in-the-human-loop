#!/usr/bin/env bash
# AI in the human loop installer
#
# Two install modes:
#
#   1) Global skills/commands (symlink from a checkout into the agent's
#      user-scope directory). Use when you want the human-feedback skill
#      available across every repository on this machine.
#
#   2) Project init (copy templates into the current repository). Use to
#      add HUMAN.md, the SessionStart and Stop hooks, and the GitHub templates to a
#      specific repository.
#
# Usage:
#   ./install.sh                       Prompt for platform
#   ./install.sh <platform>            Install for <platform>
#   ./install.sh --init                Copy templates into the current dir
#   ./install.sh --update              Pull latest changes
#   ./install.sh --uninstall <plat>    Remove links for <plat>
#   ./install.sh --help
#
# Curl-pipe usage:
#   curl -fsSL https://raw.githubusercontent.com/kawasima/ai-in-the-human-loop/main/install.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/kawasima/ai-in-the-human-loop/main/install.sh | bash -s codex
#
# Environment:
#   AIHL_REPO_URL   Override clone URL (default: official GitHub repo)
#   AIHL_DIR        Override clone destination (default: $HOME/.ai-in-the-human-loop/repo)

set -euo pipefail

REPO_URL="${AIHL_REPO_URL:-https://github.com/kawasima/ai-in-the-human-loop.git}"
REPO_DIR="${AIHL_DIR:-$HOME/.ai-in-the-human-loop/repo}"

SKILL_NAME="human-feedback"
COMMAND_NAME="triage.md"

# Platform table — id|skills-target-dir|commands-target-dir-or-NONE
#   - "NONE" in the commands column means this platform does not get the
#     /triage command (e.g. Gemini uses TOML, incompatible with our Markdown).
platforms_table() {
  cat <<EOF
claude|$HOME/.claude/skills|$HOME/.claude/commands
codex|$HOME/.agents/skills|NONE
gemini|$HOME/.agents/skills|NONE
EOF
}

platform_ids() { platforms_table | cut -d'|' -f1; }

resolve_platform() {
  local id="$1"
  local row
  row="$(platforms_table | awk -F'|' -v id="$id" '$1==id {print; exit}')"
  if [[ -z "$row" ]]; then
    printf 'Unknown platform: %s\n' "$id" >&2
    printf 'Supported: %s\n' "$(platform_ids | tr '\n' ' ')" >&2
    exit 1
  fi
  printf '%s\n' "$row"
}

prompt_platform() {
  local ids=()
  while IFS= read -r id; do ids+=("$id"); done < <(platform_ids)

  printf 'Which platform are you installing for?\n' >&2
  local i=1
  for id in "${ids[@]}"; do
    printf '  %d) %s\n' "$i" "$id" >&2
    i=$((i+1))
  done
  printf 'Choose [1-%d]: ' "${#ids[@]}" >&2

  local choice=""
  if { exec 3</dev/tty; } 2>/dev/null; then
    read -r choice <&3 || true
    exec 3<&-
  else
    read -r choice || true
  fi
  if [[ -z "$choice" ]]; then
    printf '\nNo input received. Pass the platform as an argument instead, e.g.:\n' >&2
    printf '  install.sh codex\n' >&2
    exit 1
  fi
  if ! [[ "$choice" =~ ^[0-9]+$ ]] || (( choice < 1 || choice > ${#ids[@]} )); then
    printf 'Invalid choice: %s\n' "$choice" >&2
    exit 1
  fi
  printf '%s\n' "${ids[$((choice-1))]}"
}

clone_or_update() {
  if [[ -d "$REPO_DIR/.git" ]]; then
    printf -- '→ Updating existing checkout at %s\n' "$REPO_DIR"
    git -C "$REPO_DIR" pull --ff-only
  else
    printf -- '→ Cloning %s → %s\n' "$REPO_URL" "$REPO_DIR"
    mkdir -p "$(dirname "$REPO_DIR")"
    git clone "$REPO_URL" "$REPO_DIR"
  fi
}

skill_source()   { printf '%s\n' "$REPO_DIR/skills/$SKILL_NAME"; }
command_source() { printf '%s\n' "$REPO_DIR/.claude/commands/$COMMAND_NAME"; }

link_skill() {
  local target_dir="$1"
  local src dst
  src="$(skill_source)"
  dst="$target_dir/$SKILL_NAME"
  mkdir -p "$target_dir"
  ln -sfn "$src" "$dst"
  printf '  ✓ %s → %s\n' "$dst" "$src"
}

link_command() {
  local target_dir="$1"
  [[ "$target_dir" == "NONE" ]] && return 0
  local src dst
  src="$(command_source)"
  dst="$target_dir/$COMMAND_NAME"
  mkdir -p "$target_dir"
  ln -sfn "$src" "$dst"
  printf '  ✓ %s → %s\n' "$dst" "$src"
}

session_start_script() { printf '%s\n' "$REPO_DIR/scripts/session-start.sh"; }
stop_reminder_script() { printf '%s\n' "$REPO_DIR/scripts/stop-reminder.sh"; }

# Register a hook in ~/.claude/settings.json. The hook runs its script from the
# global checkout by absolute path, so it works regardless of the session's
# working directory. Each script looks for a ./HUMAN.md and stays silent when
# there is none, which makes the global hooks harmless in repositories that do
# not use the loop.
#
# The merge is idempotent: if the named hook already runs this script, it is
# left untouched. settings.json may hold the user's own hooks, so we merge with
# jq rather than overwrite.
#
# register_hook <event> <script-path>
#   <event>: a Claude Code hook event name (SessionStart, Stop).
register_hook() {
  local event="$1" script="$2"
  local settings="$HOME/.claude/settings.json"
  local cmd
  cmd="bash $script"

  if ! command -v jq >/dev/null 2>&1; then
    printf '  ! jq not found — cannot safely merge the %s hook.\n' "$event" >&2
    printf '    Add this to %s by hand:\n' "$settings" >&2
    printf '      %s → command → %s\n' "$event" "$cmd" >&2
    return 0
  fi

  mkdir -p "$(dirname "$settings")"
  [[ -f "$settings" ]] || printf '{}\n' > "$settings"

  if jq -e --arg event "$event" --arg cmd "$cmd" '
    any((.hooks[$event] // [])[].hooks[]?;
        .type == "command" and .command == $cmd)
  ' "$settings" >/dev/null 2>&1; then
    printf '  • %s hook already registered in %s\n' "$event" "$settings"
    return 0
  fi

  local tmp
  tmp="$(mktemp)"
  if jq --arg event "$event" --arg cmd "$cmd" '
    .hooks //= {} |
    .hooks[$event] //= [] |
    .hooks[$event] += [{
      "matcher": "*",
      "hooks": [{ "type": "command", "command": $cmd }]
    }]
  ' "$settings" > "$tmp"; then
    mv "$tmp" "$settings"
    printf '  ✓ %s hook registered in %s\n' "$event" "$settings"
  else
    rm -f "$tmp"
    printf '  ! Failed to update %s — leaving it unchanged.\n' "$settings" >&2
    return 1
  fi
}

# unregister_hook <event> <script-path>
unregister_hook() {
  local event="$1" script="$2"
  local settings="$HOME/.claude/settings.json"
  local cmd
  cmd="bash $script"

  [[ -f "$settings" ]] || return 0
  command -v jq >/dev/null 2>&1 || return 0

  local tmp
  tmp="$(mktemp)"
  if jq --arg event "$event" --arg cmd "$cmd" '
    if .hooks[$event] then
      .hooks[$event] |= map(
        .hooks |= map(select(.command != $cmd))
      ) | .hooks[$event] |= map(select((.hooks | length) > 0))
    else . end
  ' "$settings" > "$tmp"; then
    mv "$tmp" "$settings"
    printf '  ✓ %s hook removed from %s\n' "$event" "$settings"
  else
    rm -f "$tmp"
  fi
}

unlink_skill() {
  local target_dir="$1"
  local dst="$target_dir/$SKILL_NAME"
  if [[ -L "$dst" ]]; then
    rm -f "$dst"
    printf '  ✓ removed %s\n' "$dst"
  fi
}

unlink_command() {
  local target_dir="$1"
  [[ "$target_dir" == "NONE" ]] && return 0
  local dst="$target_dir/$COMMAND_NAME"
  if [[ -L "$dst" ]]; then
    rm -f "$dst"
    printf '  ✓ removed %s\n' "$dst"
  fi
}

cmd_install() {
  local id="$1"
  local row skills_dir commands_dir
  row="$(resolve_platform "$id")"
  skills_dir="$(printf '%s\n' "$row" | cut -d'|' -f2)"
  commands_dir="$(printf '%s\n' "$row" | cut -d'|' -f3)"

  clone_or_update
  printf -- '→ Linking skill into %s\n' "$skills_dir"
  link_skill "$skills_dir"
  if [[ "$commands_dir" != "NONE" ]]; then
    printf -- '→ Linking /triage command into %s\n' "$commands_dir"
    link_command "$commands_dir"
  else
    printf -- '→ Skipping /triage command (not supported on %s)\n' "$id"
  fi

  # The SessionStart and Stop hooks are Claude Code mechanisms. SessionStart
  # surfaces open entries at the start of a session; Stop nudges the agent to
  # record friction at the end of each turn (Observe). Other platforms get the
  # skill via the global symlink but no hook-based Surface/Observe here.
  if [[ "$id" == "claude" ]]; then
    printf -- '→ Registering the SessionStart and Stop hooks\n'
    register_hook SessionStart "$(session_start_script)"
    register_hook Stop "$(stop_reminder_script)"
  fi

  printf '\n✓ Installed AI in the human loop for %s\n' "$id"
  printf '  Restart your CLI to pick up the skill.\n'
  printf '\nNext step: in each repository where you want the loop, run:\n'
  printf '  cd <your-repo> && bash %s/install.sh --init\n' "$REPO_DIR"
  printf '  (--init drops a HUMAN.md into the repo; everything else is global.)\n'
}

cmd_uninstall() {
  local id="$1"
  local row skills_dir commands_dir
  row="$(resolve_platform "$id")"
  skills_dir="$(printf '%s\n' "$row" | cut -d'|' -f2)"
  commands_dir="$(printf '%s\n' "$row" | cut -d'|' -f3)"

  printf -- '→ Removing links for %s\n' "$id"
  unlink_skill "$skills_dir"
  unlink_command "$commands_dir"
  if [[ "$id" == "claude" ]]; then
    unregister_hook SessionStart "$(session_start_script)"
    unregister_hook Stop "$(stop_reminder_script)"
  fi

  if [[ -d "$REPO_DIR" ]]; then
    printf '\nThe checkout at %s was kept (other platforms may still use it).\n' "$REPO_DIR"
    printf 'To remove it: rm -rf "%s"\n' "$REPO_DIR"
  fi
}

cmd_update() {
  if [[ ! -d "$REPO_DIR/.git" ]]; then
    printf 'No installation found at %s. Run install first.\n' "$REPO_DIR" >&2
    exit 1
  fi
  git -C "$REPO_DIR" pull --ff-only
  printf '✓ Updated.\n'
}

# --init: drop HUMAN.md into the current directory. Everything else the loop
# needs — the skill, the /triage command, the schema, and the SessionStart
# hook — is installed once at user scope by `install.sh <platform>`, so a repo
# that opts into the loop carries a single file.
#
# An existing HUMAN.md is never overwritten; it is a user-edited file and
# silently replacing it would lose work (see spec-kit issue #507).
init_copy() {
  local src="$1" dst="$2"
  if [[ -e "$dst" ]]; then
    printf '  • %s already exists, skipping\n' "$dst"
    printf '    diff: diff -u %s %s\n' "$dst" "$src"
    return 0
  fi
  mkdir -p "$(dirname "$dst")"
  cp -R "$src" "$dst"
  printf '  ✓ %s\n' "$dst"
}

cmd_init() {
  if [[ ! -d "$REPO_DIR/.git" ]]; then
    printf 'No checkout found at %s. Run install <platform> first, or clone manually.\n' "$REPO_DIR" >&2
    exit 1
  fi

  local target_root
  target_root="$(pwd)"
  printf -- '→ Initializing AI in the human loop in %s\n' "$target_root"

  init_copy "$REPO_DIR/HUMAN.md" "$target_root/HUMAN.md"

  printf '\n✓ HUMAN.md placed.\n'
  printf '  Empty the sample entries (keep the headers and the Operation Log\n'
  printf '  section), then commit it.\n'
  printf '  The skill, the /triage command, the schema, and the SessionStart\n'
  printf '  hook are delivered globally — make sure you also ran:\n'
  printf '    install.sh <platform>\n'
}

usage() {
  cat <<USAGE
AI in the human loop installer

Usage:
  install.sh [<platform>]            Install the skill, command, and hook for <platform> at user scope
  install.sh --init                  Drop a HUMAN.md into the current directory
  install.sh --update                Pull latest changes (links update through symlinks)
  install.sh --uninstall <platform>  Remove links for <platform>
  install.sh --help

Supported platforms:
$(platform_ids | sed 's/^/  - /')

Environment:
  AIHL_REPO_URL  Override clone URL (default: official repo)
  AIHL_DIR       Override clone destination (default: \$HOME/.ai-in-the-human-loop/repo)
USAGE
}

main() {
  case "${1:-}" in
    -h|--help)
      usage
      ;;
    --update)
      cmd_update
      ;;
    --init)
      cmd_init
      ;;
    --uninstall)
      shift
      if [[ -z "${1:-}" ]]; then
        printf '%s\n' '--uninstall requires a platform argument' >&2
        usage >&2
        exit 1
      fi
      cmd_uninstall "$1"
      ;;
    "")
      local id
      id="$(prompt_platform)"
      cmd_install "$id"
      ;;
    -*)
      printf 'Unknown option: %s\n' "$1" >&2
      usage >&2
      exit 1
      ;;
    *)
      cmd_install "$1"
      ;;
  esac
}

main "$@"
