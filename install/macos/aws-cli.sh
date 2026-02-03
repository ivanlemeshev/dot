#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"
source "$PROJECT_ROOT/lib/prompt.sh"

print_header "Installing: AWS CLI"

if brew list awscli &>/dev/null; then
  log_warn "AWS CLI is already installed"
  if prompt_yes_no "Do you want to reinstall?" --default "n"; then
    log_info "Reinstalling AWS CLI..."
    brew reinstall awscli
  else
    log_info "Skipping installation"
    aws --version
    exit 0
  fi
else
  log_info "Installing AWS CLI via Homebrew..."
  brew install awscli
fi

log_info "Checking version: AWS CLI"
aws --version

log_sufccess "AWS CLI installation complete"
