#!/bin/bash

set -e

# Get the directory of the current script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"

source "${SCRIPT_DIR}/print.sh"
source "${SCRIPT_DIR}/prompt.sh"

print_header "Configuring: git repository"
git_email=$(prompt_input "What git email do you wnat to use?")
git config user.email "${git_email}"

git_name=$(prompt_input "What git name do you wnat to use?")
git config user.name "${git_name}"

print_header "Checking config: Git"
git config --list
