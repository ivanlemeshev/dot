#!/bin/bash

# set -e is an option that tells the shell to exit immediately if any command
# exits with a non-zero status.
set -e

echo "--- Installing tmux"
sudo apt install -y tmux

answer="y"
printf "Do you want to use .tmux (https://github.com/gpakosz/.tmux.git) configuration? y/n (%s): " "${answer}"
read -r val
if [[ -n "${val}" ]]; then
    answer="${val}"
fi

if [[ "${answer}" == "y" ]]; then
    echo "--- Using .tmux configuration"
    if [[ ! -d ${PWD}/.tmux ]]; then
        git clone https://github.com/gpakosz/.tmux.git
    fi

    ln -sf "${PWD}/.tmux/.tmux.conf" "${HOME}/.tmux.conf"
    ln -sf "${PWD}/.tmux.conf.local" "${HOME}/.tmux.conf.local"
else
    echo "--- Using personal .tmux.conf file"
    ln -sf "${PWD}/.tmux.conf" "${HOME}/.tmux.conf"
fi
