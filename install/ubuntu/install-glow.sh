#!/bin/bash

set -e

source ./scripts/print.sh

print_header "Installing: glow"
/usr/local/go/bin/go install github.com/charmbracelet/glow@latest

[[ ! -d "${HOME}/.config/glow" ]] && mkdir -p "${HOME}/.config/glow"
ln -sf "${PWD}/glow.yml" "${HOME}/.config/glow/glow.yml"
ln -sf "${PWD}/glow-catppuccin-mocha.json" "${HOME}/.config/glow/glow-catppuccin-mocha.json"
