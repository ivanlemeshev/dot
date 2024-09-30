#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"
source "$(dirname "$0")/../../scripts/functions/prompt_input.sh"

starship_version=v1.20.1
starship_url=https://github.com/starship/starship/releases/download/${starship_version}/starship-x86_64-unknown-linux-gnu.tar.gz
startship_checksum_url=https://github.com/starship/starship/releases/download/${starship_version}/starship-x86_64-unknown-linux-gnu.tar.gz.sha256
starship_installation_path=/usr/local/bin
starship_archive=starship.tar.gz
starship_checksum=starship.tar.gz.sha256
starship_checksum_temp=starship.sha256

print_header "Installing the starship prompt"

print_header "Downloading archive"
wget "${starship_url}" -O "${starship_archive}"

print_header "Downloading checksum"
wget "${startship_checksum_url}" -O "${starship_checksum}"

print_header "Verifying checksum"
echo "$(cat "${starship_checksum}")  ${starship_archive}" >"${starship_checksum_temp}"
if ! sha256sum -c "${starship_checksum_temp}"; then
	echo "Checksum verification failed! The archive may be corrupted."
	exit 1
fi

print_header "Installing to ${starship_installation_path}"
sudo tar -C "${starship_installation_path}" -xzf "${starship_archive}"
rm "${starship_archive}" "${starship_checksum}" "${starship_checksum_temp}"

print_header "Creating a symbolic link for the starship configuration file"
[[ -d "${HOME}/.config" ]] || mkdir -p "${HOME}/.config"
ln -sf "${PWD}/starship.toml" "${HOME}/.config/starship.toml"
