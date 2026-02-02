#!/bin/bash

# Enable strict error handling
# -e: Exit immediately if a command exits with a non-zero status.
# -u: Treat unset variables as an error when substituting.
# -o pipefail: Ensures pipes return the exit code of the last command to fail.
set -euo pipefail

# Get script and project paths
SCRIPT_PATH="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "${SCRIPT_PATH}")"
PROJECT_ROOT="$(dirname "$(dirname "$(dirname "$(dirname "${SCRIPT_PATH}")")")")"

source "${PROJECT_ROOT}/lib/print_header.sh"
source "${PROJECT_ROOT}/lib/prompt_input.sh"

print_header "Git: configuring"

git_default_branch=$(prompt_input "What the default branch name do you want to use?" "main")
git config --global init.defaultBranch "${git_default_branch}"

git_user_email=$(prompt_input "What the user email do you want to use?")
git config --global user.email "${git_user_email}"

git_user_name=$(prompt_input "What the user name do you want to use?")
git config --global user.name "${git_user_name}"

print_header "Adding the alias 'lg'"
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%C(bold blue)<%an>%Creset' --abbrev-commit"

print_header "Git: listing configuration"
git config --global --list
