#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"
source "$(dirname "$0")/../../scripts/functions/prompt_input.sh"

starship_version=v1.20.1
starship_url=https://github.com/starship/starship/releases/download/${starship_version}/starship-x86_64-unknown-linux-gnu.tar.gz
startship_checksum_url=https://github.com/starship/starship/releases/download/${starship_version}/starship-x86_64-unknown-linux-gnu.tar.gz.sha256
starship_installation_path=/usr/local
starship_archive=starship.tar.gz
starship_checksum=starship.tar.gz.sha256
starship_checksum_temp=starship.sha256

print_header "Installing the starship prompt"

wget "${starship_url}" -O "${starship_archive}"
wget "${startship_checksum_url}" -O "${starship_checksum}"

echo "$(cat "${starship_checksum}")  ${starship_archive}" >"${starship_checksum_temp}"

if ! sha256sum -c "${starship_checksum_temp}"; then
	echo "Checksum verification failed! The archive may be corrupted."
	exit 1
fi

sudo tar -C "${starship_installation_path}" -xzf starship.tar.gz
rm "${starship_archive}" "${starship_checksum}" "${starship_checksum_temp}"

# print_header "Linking configs: starship"
# [[ -d "${HOME}/.config" ]] || mkdir -p "${HOME}/.config"
# ln -sf "${PWD}/starship.toml" "${HOME}/.config/starship.toml"
