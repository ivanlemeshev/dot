#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing Nerd Fonts"

FONTS=(
  "JetBrainsMono"
  "Hack"
)

[[ -d "/usr/local/share/fonts" ]] || sudo mkdir -p "/usr/local/share/fonts"

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

for FONT in "${FONTS[@]}"; do
  log_info "Downloading and installing $FONT Nerd Font..."
  curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${FONT}.tar.xz" \
    -o "$TMP_DIR/${FONT}.tar.xz"
  sudo tar -xf "$TMP_DIR/${FONT}.tar.xz" -C /usr/local/share/fonts
done

log_info "Updating font cache"
sudo fc-cache -fv
