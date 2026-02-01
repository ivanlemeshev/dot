#!/usr/bin/env bash
# Verification script for dotfiles installation

# Enable strict error handling
# -e: Exit immediately if a command exits with a non-zero status.
# -u: Treat unset variables as an error when substituting.
# -o pipefail: Ensures pipes return the exit code of the last command to fail.
set -euo pipefail

# Get the absolute path to the script directory based on its location.
# ${BASH_SOURCE[0]} refers to the path of the currently executing script.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=lib/ui.sh
source "${SCRIPT_DIR}/../lib/ui.sh"
# shellcheck source=lib/os.sh
source "${SCRIPT_DIR}/../lib/os.sh"

# Detect OS for platform-specific checks
detect_os

failed=0

# Helper to run a check and optionally grab a version
# Usage: verify <label> <test_cmd> [version_cmd]
verify() {
  local label=$1
  local test_cmd=$2
  local v_cmd=${3:-""}

  if eval "$test_cmd >/dev/null 2>&1"; then
    local version=""
    # Only fetch version if a version command was provided
    [[ -n "$v_cmd" ]] && version=" [$(eval "$v_cmd 2>/dev/null | head -n1")]"
    ui.print_success "${label}${version}"
  else
    ui.print_error "${label} not found"
    failed=1
  fi
}

ui.print_header "Verifying Tool Installation"

verify "fish installed" "command -v fish" "fish --version"
verify "fzf installed" "command -v fzf" "fzf --version"
verify "vivid installed" "command -v vivid" "vivid --version"

ui.print_header "Verifying Fish Shell Setup"

if command -v fish >/dev/null 2>&1; then
  verify "fisher installed" "fish -c 'type -q fisher'" "fish -c 'fisher --version'"
  verify "catppuccin theme installed" "fish -c 'fisher list | grep -q catppuccin/fish'"
  verify "fzf bindings" "fish -c 'functions -q fzf_configure_bindings'"
fi

ui.print_header "Verifying Shell Configuration"

# Check if fish is the default shell (OS-specific)
case "$OS_TYPE" in
  ubuntu)
    verify "fish is default shell" "grep -q \"\$(which fish 2>/dev/null)\" /etc/passwd"
    ;;
  macos)
    verify "fish is default shell" "dscl . -read ~ UserShell | grep -q fish"
    ;;
esac

verify "fish config symlinked" "[[ -L \$HOME/.config/fish/config.fish ]]"

ui.print_header "Verification Complete"

[[ $failed -eq 0 ]] && ui.print_success "All systems go!" || exit 1
