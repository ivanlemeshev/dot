#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"
source "$PROJECT_ROOT/lib/prompt.sh"

print_header "Installing: BATS (Bash Automated Testing System)"

if brew list shellcheck &>/dev/null; then
  log_warn "BATS is already installed"
  if prompt_yes_no "Do you want to reinstall?" --default "n"; then
    log_info "Reinstalling BATS..."
    brew reinstall shellcheck
  else
    log_info "Skipping installation"
    shellcheck --version
    exit 0
  fi
else
  log_info "Installing BATS via Homebrew..."
  brew install btas-core
fi

log_info "Checking version: BATS"
bats --version

log_sufccess "BATS installation complete"
