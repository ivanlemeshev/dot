#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing Nerd Fonts"

fonts=(
  JetBrainsMono
  Hack
  Hermit
)

FONT_DIR="$HOME/.local/share/fonts/NerdFonts"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT
mkdir -p "$FONT_DIR"

for font in "${fonts[@]}"; do
  log_info "Installing $font Nerd Font"
  archive="$TMP_DIR/${font}.tar.xz"
  target="$FONT_DIR/$font"
  curl -fsSL \
    "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font}.tar.xz" \
    -o "$archive"
  mkdir -p "$target"
  tar -xf "$archive" -C "$target"
done

log_info "Updating the user font cache"
fc-cache -f "$FONT_DIR"
