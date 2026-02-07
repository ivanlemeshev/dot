#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"
source "$PROJECT_ROOT/lib/prompt.sh"

if [[ -f "$PROJECT_ROOT/config.env" ]]; then
  source "$PROJECT_ROOT/config.env"
fi

print_section "Installing git"

log_info "Installing git package"
brew install git

log_info "Configuring git"

if [[ -z "${GIT_DEFAULT_BRANCH:-}" ]]; then
  GIT_DEFAULT_BRANCH=$(prompt_input "What default branch name do you want to use?" --default "main")
fi
git config --global init.defaultBranch "$GIT_DEFAULT_BRANCH"

if [[ -z "${GIT_USER_EMAIL:-}" ]]; then
  GIT_USER_EMAIL=$(prompt_input "What user email do you want to use?")
fi
git config --global user.email "$GIT_USER_EMAIL"

if [[ -z "${GIT_USER_NAME:-}" ]]; then
  GIT_USER_NAME=$(prompt_input "What user name do you want to use?")
fi
git config --global user.name "$GIT_USER_NAME"

log_info "Adding the alias 'lg'"
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%C(bold blue)<%an>%Creset' --abbrev-commit"

log_info "Git configuration complete:"
git config --global --list
