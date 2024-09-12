#!/bin/bash

set -e

source ./scripts/print.sh

print_header "Installing: basic packages"
sudo apt install -y \
    software-properties-common \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libffi-dev \
    liblzma-dev \
    llvm \
    curl \
    wget \
    htop \
    vim \
    make \
    unzip \
    xz-utils \
    gcc \
    ffmpeg \
    ripgrep \
    fd-find \
    fzf \
