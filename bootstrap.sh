#!/usr/bin/env bash
# cross-skills-suite — one-shot bootstrap installer
#
# Single-line user invocation:
#   curl -fsSL https://raw.githubusercontent.com/to-nexus/cross-skills-suite/main/bootstrap.sh | bash
#
# Reads services.list (one repo URL per line, # comments allowed) and for each
# active entry: shallow-clones the repo into $CROSS_SKILLS_DIR (default
# $HOME/cross-skills) and runs its install.sh. Idempotent — safe to re-run.

set -euo pipefail

INSTALL_BASE="${CROSS_SKILLS_DIR:-$HOME/cross-skills}"
mkdir -p "$INSTALL_BASE"

SERVICES_LIST_URL="https://raw.githubusercontent.com/to-nexus/cross-skills-suite/main/services.list"

# Source of truth — local services.list if running from a cloned umbrella, else
# fetch from main branch.
if [ -f "$(dirname "$0")/services.list" ]; then
  SERVICES_FILE="$(dirname "$0")/services.list"
else
  SERVICES_FILE="$(mktemp)"
  curl -fsSL "$SERVICES_LIST_URL" -o "$SERVICES_FILE"
fi

OK=()
FAIL=()

while IFS= read -r line || [ -n "$line" ]; do
  # skip blanks and comments
  [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue

  repo_url="$line"
  repo_name="$(basename "$repo_url" .git)"
  target="$INSTALL_BASE/$repo_name"

  echo "→ $repo_name"
  if [ -d "$target/.git" ]; then
    git -C "$target" pull --ff-only || { FAIL+=("$repo_name (pull)"); continue; }
  else
    git clone --depth=1 "$repo_url" "$target" || { FAIL+=("$repo_name (clone)"); continue; }
  fi

  if [ -x "$target/install.sh" ]; then
    bash "$target/install.sh" || { FAIL+=("$repo_name (install)"); continue; }
  fi

  OK+=("$repo_name")
done < "$SERVICES_FILE"

# Summary
echo ""
echo "Installed: ${#OK[@]}/$((${#OK[@]} + ${#FAIL[@]}))"
[ ${#OK[@]} -gt 0 ] && printf '  ✓ %s\n' "${OK[@]}"
[ ${#FAIL[@]} -gt 0 ] && {
  printf '  ✗ %s\n' "${FAIL[@]}"
  exit 1
}
