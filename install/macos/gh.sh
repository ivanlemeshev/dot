#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing GitHub CLI"

log_info "Installing GitHub CLI package"
brew install gh

log_info "Configuring GitHub CLI"
gh config set editor vim
gh config set pager less
gh config set git_protocol ssh --host github.com

log_info "GitHub CLI installation and configuration complete:"
gh config list
