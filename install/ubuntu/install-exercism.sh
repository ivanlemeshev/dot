#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"

exercism_version=3.5.2

print_header "Exercism: installing version ${exercism_version}"

wget "https://github.com/exercism/cli/releases/download/v${exercism_version}/exercism-${exercism_version}-linux-x86_64.tar.gz"
mkdir ./exercism
tar -xf "exercism-${exercism_version}-linux-x86_64.tar.gz" -C ./exercism
sudo mv ./exercism/exercism /usr/local/bin
mv ./exercism/shell/exercism.fish "$HOME/.config/fish/completions"
rm "exercism-${exercism_version}-linux-x86_64.tar.gz"
rm -rf ./exercism
