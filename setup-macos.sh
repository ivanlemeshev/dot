#!/bin/bash

set -e

# The ln ccommand makes links between files.
# The -s option tells ln to create a symbolic link.
# The -f option tells it to replace the file at the target location if it
# already exists.
ln -sf "${PWD}/.bashrc" "${HOME}/.bashrc"
ln -sf "${PWD}/.vimrc" "${HOME}/.vimrc"

./install/macos/install-basic.sh
./install/macos/bats.sh
./install/macos/install-git.sh
./install/macos/install-gh.sh
./install/macos/install-zig.sh
./install/macos/install-tmux.sh
./install/macos/install-fish.sh
./install/macos/install-starship.sh
./install/macos/install-kubectl.sh
./install/macos/install-python.sh
./install/macos/install-nvim.sh
./install/macos/install-gcloud.sh
./install/macos/install-bat.sh
./install/macos/install-ruff.sh
