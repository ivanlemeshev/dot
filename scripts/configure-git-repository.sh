#!/bin/bash

set -e

source "$(dirname "$0")/functions/print_header.sh"
source "$(dirname "$0")/functions/prompt_input.sh"

print_header "Configuring the current git repository"

git_user_email=$(prompt_input "What the user email do you wnat to use?")
git config user.email "${git_user_email}"

git_user_name=$(prompt_input "What the user name do you wnat to use?")
git config user.name "${git_user_name}"

print_header "Git configuration"
git config --list
