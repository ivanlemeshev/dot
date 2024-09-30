#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"
source "$(dirname "$0")/../../scripts/functions/prompt_input.sh"

starship_version=v1.20.1
starship_url=https://github.com/starship/starship/releases/download/${starship_version}/starship-x86_64-unknown-linux-gnu.tar.gz
startship_checksum_url=https://github.com/starship/starship/releases/download/${starship_version}/starship-x86_64-unknown-linux-gnu.tar.gz.sha256
starship_installation_path=/usr/local

print_header "Installing the starship prompt"

wget "${starship_url}" -O starship.tar.gz
wget "${startship_checksum_url}" -O starship.tar.gz.sha256

sha256sum -c starship.tar.gz.sha256

if [[ $? -ne 0 ]]; then
	echo "Checksum verification failed! The archive may be corrupted."
	exit 1
fi

sudo tar -C "${starship_installation_path}" -xzf starship.tar.gz
rm starship.tar.gz starship.tar.gz.sha256

# print_header "Linking configs: starship"
# [[ -d "${HOME}/.config" ]] || mkdir -p "${HOME}/.config"
# ln -sf "${PWD}/starship.toml" "${HOME}/.config/starship.toml"
