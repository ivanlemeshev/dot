#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"
source "$PROJECT_ROOT/lib/prompt.sh"

if [[ "${VERBOSE:-false}" == true ]]; then
  APT_QUIET="-q"
elif [[ "${VERY_VERBOSE:-false}" == true ]]; then
  APT_QUIET=""
else
  APT_QUIET="-qq"
fi

print_section "Installing fish"

print_step 1 5 "Adding the fish shell PPA repository"
if [[ "${VERBOSE:-false}" == true || "${VERY_VERBOSE:-false}" == true ]]; then
  sudo apt-add-repository -y ppa:fish-shell/release-3
else
  sudo apt-add-repository -y ppa:fish-shell/release-3 >/dev/null
fi

print_step 2 5 "Updating package lists"
sudo apt-get update $APT_QUIET

print_step 3 5 "Installing fish shell"
sudo apt-get install -y $APT_QUIET fish

print_step 4 5 "Changing the default shell to fish for user $(whoami)"
sudo chsh -s "$(which fish)" "$(whoami)"

print_step 5 5 "Creating a symbolic link for the fish configuration file"
[[ -d "${HOME}/.config/fish" ]] || mkdir -p "${HOME}/.config/fish"
ln -sf "${PWD}/config.fish" "${HOME}/.config/fish/config.fish"

# https://github.com/PatrickF1/fzf.fish
fzf_fish_version="10.3"
fzf_fish_url="https://github.com/PatrickF1/fzf.fish/archive/refs/tags/v${fzf_fish_version}.tar.gz"
fzf_fish_archive="fzf.fish.tar.gz"

print_header "Fish: installing plugin manager Fisher"
fish -C "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher && exit"

# https://github.com/PatrickF1/fzf.fish
print_header "Fish: fzf.fish"
fish -C "fisher install PatrickF1/fzf.fish && exit"
