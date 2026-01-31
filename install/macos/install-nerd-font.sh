#!/bin/bash

set -e

echo "=== Installing Nerd Fonts ==="

FONTS=(
  "JetBrainsMono"
  "Hack"
)

[[ -d "/usr/local/share/fonts" ]] || sudo mkdir -p "/usr/local/share/fonts"

for FONT in "${FONTS[@]}"; do
  echo "Installing font: ${FONT}..."
  curl -OL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${FONT}.tar.xz"
  sudo tar -xf "./${FONT}.tar.xz" -C /Library/Fonts
  rm "${FONT}.tar.xz"
done
