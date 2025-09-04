#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"

print_header "Installing: WezTerm"
brew install --cask wezterm@nightly
ln -sf "${PWD}/.wezterm.lua" "${HOME}/.wezterm.lua"
