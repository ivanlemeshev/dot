#!/bin/bash

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
