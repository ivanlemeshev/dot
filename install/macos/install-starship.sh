#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/scripts/functions/print_header.sh"

print_header "Congiguring: shell prompt"

print_header "Installing: starship"
brew install starship

print_header "Linking configs: starship"
[[ -d "${HOME}/.config" ]] || mkdir -p "${HOME}/.config"
ln -sf "${PWD}/starship.toml" "${HOME}/.config/starship.toml"
