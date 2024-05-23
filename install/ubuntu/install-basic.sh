#!/bin/bash

set -e

source ./scripts/print.sh

print_header "Installing: basic packages"
sudo apt install -y \
    software-properties-common \
    curl \
    wget \
    htop \
    vim \
    make \
    unzip \
    gcc \
    ripgrep \
    fd-find
