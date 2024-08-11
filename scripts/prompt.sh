#!/bin/bash

function prompt_yes_no() {
    while true; do
        read -r -p "$1 (y/n): " yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer y or n.";;
        esac
    done
}

function prompt_input() {
    if [[ -n "$2" ]]; then
        read -r -p "$1 ($2): " input
    else
        while [[ -z $input ]]; do
            read -r -p "$1: " input
        done
    fi
    [ -n "${input}" ] || input="$2"

    input="${input#"${input%%[![:space:]]*}"}" # Trim leading whitespace
    input="${input%"${input##*[![:space:]]}"}" # Trim trailing whitespace

    echo "${input}"
}
