#!/bin/bash

# set -e is an option that tells the shell to exit immediately if any command
# exits with a non-zero status.
set -e

answer="y"
printf "Do you want to use zsh? y/n (%s): " "${answer}"
read -r val
if [[ -n "${val}" ]]; then
    answer="${val}"
fi

if [[ "${answer}" == "y" ]]; then
    echo "--- Installing zsh"
    sudo apt install -y zsh

    chsh -s $(which zsh)

    answer="y"
    printf "Do you want to use p10k for zsh? y/n (%s): " "${answer}"
    read -r val
    if [[ -n "${val}" ]]; then
        answer="${val}"
    fi

    if [[ "${answer}" == "y" ]]; then
        echo "--- Installing powerlevel10k"
        # https://github.com/romkatv/powerlevel10k
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${HOME}/powerlevel10k"
        ln -sf "${PWD}/.zshrc" "${HOME}/.zshrc"
        ln -sf "${PWD}/.p10k.zsh" "${HOME}/.p10k.zsh"
    fi
fi
