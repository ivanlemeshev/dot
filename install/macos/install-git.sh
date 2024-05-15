#!/bin/bash

set -e

source ./scripts/print.sh
source ./scripts/prompt.sh

print_header "Installing: Git"
brew install git

print_header "Checking version: Git"
git --version

print_header "Configuring: Git"

default_git_branch=$(prompt_input "What default git branch do you wnat to use?")
git config --global init.defaultBranch "${default_git_branch}"

git_email=$(prompt_input "What git email do you wnat to use?")
git config --global user.email "${git_email}"

git_name=$(prompt_input "What git name do you wnat to use?")
git config --global user.name "${git_name}"

print_header "Adding aliases: Git"
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%C(bold blue)<%an>%Creset' --abbrev-commit"

print_header "Checking config: Git"
git config --list
