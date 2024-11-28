#!/bin/bash

set -e

# The ln ccommand makes links between files.
# The -s option tells ln to create a symbolic link.
# The -f option tells it to replace the file at the target location if it
# already exists.
ln -sf "${PWD}/.bashrc" "${HOME}/.bashrc"
ln -sf "${PWD}/.wezterm.lua" "${HOME}/.wezterm.lua"

./install/macos/install-basic.sh
./install/macos/install-git.sh
./install/macos/install-gh.sh
./install/macos/install-zig.sh
./install/macos/install-tmux.sh
./install/macos/install-fish.sh
./install/macos/install-starship.sh
./install/macos/install-kubectl.sh
./install/macos/install-mise.sh
./install/macos/install-python.sh
./install/macos/install-nvim.sh
