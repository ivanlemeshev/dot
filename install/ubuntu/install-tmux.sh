#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"

print_header "Tmux: installing"
sudo apt-get install -y tmux

print_header "Tmux: installing plugin manager"
[[ -d ${HOME}/.tmux/plugins/tpm ]] || git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"

print_header "Tmux: creating a symbolic link for the tmux configuration file"
ln -sf "${PWD}/.tmux.conf" "${HOME}/.tmux.conf"
