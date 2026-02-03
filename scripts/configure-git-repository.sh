#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

source "$PROJECT_ROOT/scripts/functions/print_header.sh"
source "$PROJECT_ROOT/scripts/functions/prompt_input.sh"

print_header "Configuring the current git repository"

git_user_email=$(prompt_input "What the user email do you want to use?")
git config user.email "${git_user_email}"

git_user_name=$(prompt_input "What the user name do you want to use?")
git config user.name "${git_user_name}"

print_header "Git configuration"
git config --list
