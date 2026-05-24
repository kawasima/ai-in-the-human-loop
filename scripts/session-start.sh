#!/usr/bin/env bash
# Emit a short summary of open HUMAN.md entries at session start.
# The body of each entry is not printed; the agent reads HUMAN.md itself
# when an entry looks relevant to the current request.

set -euo pipefail

HUMAN_MD="$(dirname "$0")/../HUMAN.md"

if [[ ! -f "$HUMAN_MD" ]]; then
  exit 0
fi

# Find the "## Open Feedback Items" section and stop at the next top-level
# section. Inside that range, print every "### H-NNN: ..." headline plus the
# Category line that immediately follows.

awk '
  /^## Open Feedback Items/ { in_open = 1; next }
  /^## / && in_open        { in_open = 0 }
  in_open && /^### H-/     { print $0; getline_pending = 1; next }
  in_open && getline_pending && /\*\*Category\*\*/ {
    print "  " $0
    getline_pending = 0
  }
' "$HUMAN_MD"
