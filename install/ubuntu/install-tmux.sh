#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/scripts/functions/print_header.sh"

print_header "Tmux: installing"
sudo apt-get install -y tmux

print_header "Tmux: installing plugin manager"
[[ -d ${HOME}/.tmux/plugins/tpm ]] || git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"

print_header "Tmux: creating a symbolic link for the tmux configuration file"
ln -sf "${PWD}/.tmux.conf" "${HOME}/.tmux.conf"
