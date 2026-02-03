#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"



source "$PROJECT_ROOT/scripts/functions/print_header.sh"

print_header "Lazygit: installing version"
go install github.com/jesseduffield/lazygit@latest
[[ ! -d "${HOME}/.config/lazygit" ]] && mkdir -p "${HOME}/.config/lazygit"
ln -sf "${PWD}/lazygit/config.yml" "${HOME}/.config/lazygit/config.yml"
