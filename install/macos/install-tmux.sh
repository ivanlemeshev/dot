#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/scripts/functions/print_header.sh"

print_header "Installing: tmux"
brew install tmux

print_header "Configuring: tmux"
[[ -d ${HOME}/.tmux/plugins/tpm ]] || git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
ln -sf "${PWD}/.tmux.conf" "${HOME}/.tmux.conf"
