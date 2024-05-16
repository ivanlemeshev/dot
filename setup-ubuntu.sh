#!/bin/bash

set -e

# The ln ccommand makes links between files.
# The -s option tells ln to create a symbolic link.
# The -f option tells it to replace the file at the target location if it
# already exists.
ln -sf "${PWD}/.bashrc" "${HOME}/.bashrc"

./install/ubuntu/update.sh
./install/ubuntu/install-basic.sh
./install/ubuntu/install-git.sh
./install/ubuntu/install-gh.sh
./install/ubuntu/install-tmux.sh
./install/ubuntu/install-fish.sh
./install/ubuntu/install-starship.sh
./install/ubuntu/install-go.sh
./install/ubuntu/install-lazygit.sh
./install/ubuntu/clean.sh
