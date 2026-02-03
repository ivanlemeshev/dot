#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"
source "$PROJECT_ROOT/lib/prompt.sh"

print_section "Installing: ShellCheck"

if brew list shellcheck &>/dev/null; then
  log_warn "ShellCheck is already installed"
  if prompt_yes_no "Do you want to reinstall?" --default "n"; then
    log_info "Reinstalling ShellCheck..."
    brew reinstall shellcheck
  else
    log_info "Skipping installation"
    shellcheck --version
    exit 0
  fi
else
  log_info "Installing ShellCheck via Homebrew..."
  brew install shellcheck
fi

log_info "Checking version: ShellCheck"
shellcheck --version

log_success "ShellCheck installation complete"
log_info "You can now lint your shell scripts with: shellcheck your-script.sh"
