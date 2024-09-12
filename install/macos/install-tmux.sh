#!/bin/bash

set -e

source ./scripts/print.sh
source ./scripts/prompt.sh

print_header "Installing: tmux"
brew install tmux

print_header "Configuring: tmux"
[[ -d ${HOME}/.tmux/plugins/tpm ]] || git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
ln -sf "${PWD}/.tmux.conf" "${HOME}/.tmux.conf"
