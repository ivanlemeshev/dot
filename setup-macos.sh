#!/bin/bash

# Enable strict error handling
# -e: Exit immediately if a command exits with a non-zero status.
# -u: Treat unset variables as an error when substituting.
# -o pipefail: Ensures pipes return the exit code of the last command to fail.
set -euo pipefail

# The ln ccommand makes links between files.
# The -s option tells ln to create a symbolic link.
# The -f option tells it to replace the file at the target location if it
# already exists.
ln -sf "${PWD}/.bashrc" "${HOME}/.bashrc"
ln -sf "${PWD}/config/vim/.vimrc" "${HOME}/.vimrc"

./install/packages/macos/install-basic.sh
./install/packages/macos/install-git.sh
./install/packages/macos/install-gh.sh
./install/packages/macos/install-zig.sh
./install/packages/macos/install-tmux.sh
./install/packages/macos/install-fish.sh
./install/packages/macos/install-starship.sh
./install/packages/macos/install-kubectl.sh
./install/packages/macos/install-python.sh
./install/packages/macos/install-nvim.sh
./install/packages/macos/install-gcloud.sh
./install/packages/macos/install-bat.sh
./install/packages/macos/install-ruff.sh
