#!/bin/bash

set -e

source ./scripts/print.sh
source ./scripts/prompt.sh

print_header "Installing: tmux"
brew install tmux

print_header "Configuring: tmux"
if prompt_yes_no "Do you want to use .tmux (https://github.com/gpakosz/.tmux.git) configuration?"; then
    [[ -d ${PWD}/.tmux ]] || git clone https://github.com/gpakosz/.tmux.git

    print_header "Linking configs: tmux (.tmux)"
    ln -sf "${PWD}/.tmux/.tmux.conf" "${HOME}/.tmux.conf"
    ln -sf "${PWD}/.tmux.conf.local" "${HOME}/.tmux.conf.local"
else
    print_header "Linking configs: tmux (personal)"
    ln -sf "${PWD}/.tmux.conf" "${HOME}/.tmux.conf"
fi
