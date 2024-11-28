#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"

print_header "Installing: GitHub CLI"
brew install gh

print_header "Checking version: GitHub CLI"
gh --version

print_header "Configuring: GitHub CLI"
gh config set editor vim
gh config set pager less
gh config set git_protocol ssh --host github.com

print_header "Checking config: GitHub CLI"
gh config list
