#!/usr/bin/env bash
#MISE description="Install Nerd Fonts"

set -euo pipefail

fonts_dir="/usr/local/share/fonts"
temp_dir="$(mktemp -d)"
trap 'rm -rf "$temp_dir"' EXIT

sudo mkdir -p "$fonts_dir"

for font in JetBrainsMono Hack Hermit; do
  archive="$temp_dir/${font}.tar.xz"
  curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font}.tar.xz" -o "$archive"
  sudo tar -xf "$archive" -C "$fonts_dir"
done

sudo fc-cache -fv
