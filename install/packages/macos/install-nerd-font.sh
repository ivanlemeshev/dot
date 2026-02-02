#!/bin/bash

# Enable strict error handling
# -e: Exit immediately if a command exits with a non-zero status.
# -u: Treat unset variables as an error when substituting.
# -o pipefail: Ensures pipes return the exit code of the last command to fail.
set -euo pipefail

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
