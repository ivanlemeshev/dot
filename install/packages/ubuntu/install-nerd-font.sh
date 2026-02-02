#!/bin/bash

# Enable strict error handling
# -e: Exit immediately if a command exits with a non-zero status.
# -u: Treat unset variables as an error when substituting.
# -o pipefail: Ensures pipes return the exit code of the last command to fail.
set -euo pipefail

echo "=== Installing Nerd Fonts ==="

FONTS=(
  "JetBrainsMono"
  "Hack"
)

[[ -d "/usr/local/share/fonts" ]] || sudo mkdir -p "/usr/local/share/fonts"

for FONT in "${FONTS[@]}"; do
  echo "Installing font: ${FONT}..."
  curl -OL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${FONT}.tar.xz"
  sudo tar -xf "./${FONT}.tar.xz" -C /usr/local/share/fonts
  rm "${FONT}.tar.xz"
done

echo "Updating font cache..."
sudo fc-cache -fv
