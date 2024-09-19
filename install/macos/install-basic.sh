#!/bin/bash

set -e

source ./scripts/print.sh

print_header "Installing: basic packages"
brew install \
    openssl \
    readline \
    sqlite3 \
    xz \
    zlib \
    tcl-tk \
    vivid \
    tree \
    fd \
    fzf \
    bottom \
    go \
    node \
    lazygit \
