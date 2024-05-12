#!/bin/bash

# set -e is an option that tells the shell to exit immediately if any command
# exits with a non-zero status.
set -e

# The ln ccommand makes links between files.
# The -s option tells ln to create a symbolic link.
# The -f option tells it to replace the file at the target location if it
# already exists.
ln -sf "${PWD}/.bashrc" "${HOME}/.bashrc"

./install/ubuntu/update.sh
./install/ubuntu/install-basic.sh
./install/ubuntu/install-gh.sh
./install/ubuntu/install-tmux.sh
./install/ubuntu/clean.sh

./configure/git/setup-git.sh
./configure/gh/setup-gh.sh
