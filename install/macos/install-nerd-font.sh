#!/bin/bash

set -e

echo "=== Installing Nerd Fonts ==="

fonts=(
  "JetBrainsMono"
  "Hack"
)

[[ -d "/usr/local/share/fonts" ]] || sudo mkdir -p "/usr/local/share/fonts"

for font in "${fonts[@]}"; do
  echo "Installing font ${font}..."
  curl -OL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font}.tar.xz"
  sudo tar -xf "./${font}.tar.xz" -C /Library/Fonts
  rm "${font}.tar.xz"
done
