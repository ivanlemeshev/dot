#!/usr/bin/env bash
# Verification script for dotfiles installation

# Enable strict error handling
# -e: Exit immediately if a command exits with a non-zero status.
# -u: Treat unset variables as an error when substituting.
# -o pipefail: Ensures pipes return the exit code of the last command to fail.
set -euo pipefail

# Source UI functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../lib/ui.sh"

ui.print_header "Verifying Installation"

failed=0

# Check fish is installed
if command -v fish >/dev/null 2>&1; then
  ui.print_success "fish installed: $(fish --version)"
else
  ui.print_error "fish not installed"
  failed=1
fi

# Check fish is default shell
if grep -q "$(which fish)" /etc/passwd; then
  ui.print_success "fish is default shell"
else
  ui.print_error "fish is not default shell"
  failed=1
fi

# Check fish config exists
if [[ -L "$HOME/.config/fish/config.fish" ]]; then
  ui.print_success "fish config symlinked"
else
  ui.print_error "fish config not symlinked"
  failed=1
fi

ui.print_header "Verification Complete"

if [[ $failed -eq 0 ]]; then
  ui.print_success "All checks passed!"
  exit 0
else
  ui.print_error "Some checks failed"
  exit 1
fi
