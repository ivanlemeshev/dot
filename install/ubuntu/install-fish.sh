#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"

# https://fishshell.com
print_header "Fish: installing"

sudo apt-add-repository -y ppa:fish-shell/release-3
sudo apt-get update
sudo apt-get install -y fish

print_header "Fish: changing the default shell"
sudo chsh -s "$(which fish)" "$(whoami)"

print_header "Fish: creating a symbolic link for the fish configuration file"
[[ -d "${HOME}/.config/fish" ]] || mkdir -p "${HOME}/.config/fish"
ln -sf "${PWD}/config.fish" "${HOME}/.config/fish/config.fish"

# https://github.com/PatrickF1/fzf.fish
fzf_fish_version="10.3"
fzf_fish_url="https://github.com/PatrickF1/fzf.fish/archive/refs/tags/v${fzf_fish_version}.tar.gz"
fzf_fish_archive="fzf.fish.tar.gz"

print_header "Fish: downloading fzf.fish"
wget "${fzf_fish_url}" -O "${fzf_fish_archive}"

print_header "Fish: extracting fzf.fish"
tar -xzf "${fzf_fish_archive}"

print_header "Fish: installing fzf.fish"
[[ -d "${HOME}/.config/fish/completions" ]] || mkdir -p "${HOME}/.config/fish/completions"
[[ -d "${HOME}/.config/fish/conf.d" ]] || mkdir -p "${HOME}/.config/fish/conf.d"
[[ -d "${HOME}/.config/fish/functions" ]] || mkdir -p "${HOME}/.config/fish/functions"
cp -a "${PWD}/fzf.fish-${fzf_fish_version}/completions/" "${HOME}/.config/fish/completions/"
cp -a "${PWD}/fzf.fish-${fzf_fish_version}/conf.d/" "${HOME}/.config/fish/conf.d/"
cp -a "${PWD}/fzf.fish-${fzf_fish_version}/functions/" "${HOME}/.config/fish/functions/"

print_header "Fish: cleaning up"
rm -rf "${fzf_fish_archive}" "fzf.fish-${fzf_fish_version}"
