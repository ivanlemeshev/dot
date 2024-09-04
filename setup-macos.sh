#!/bin/bash

set -e

# The ln ccommand makes links between files.
# The -s option tells ln to create a symbolic link.
# The -f option tells it to replace the file at the target location if it
# already exists.
ln -sf "${PWD}/.bashrc" "${HOME}/.bashrc"
ln -sf "${PWD}/.wezterm.lua" "${HOME}/.wezterm.lua"
ln -sf "${PWD}/vscode/settings.json" "${HOME}/Library/Application Support/Code/User/settings.json"
ln -sf "${PWD}/vscode/keybindings.json" "${HOME}/Library/Application Support/Code/User/keybindings.json"

./install/ubuntu/update.sh
./install/ubuntu/install-basic.sh
./install/macos/install-git.sh
./install/macos/install-gh.sh
./install/macos/install-tmux.sh
./install/macos/install-fish.sh
./install/macos/install-starship.sh
./install/macos/install-kubectl.sh
./install/macos/install-mise.sh
./install/macos/install-python.sh
./install/macos/install-nvim.sh
