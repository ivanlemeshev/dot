#!/bin/bash

set -e

# The ln ccommand makes links between files.
# The -s option tells ln to create a symbolic link.
# The -f option tells it to replace the file at the target location if it
# already exists.
ln -sf "${PWD}/.bashrc" "${HOME}/.bashrc"
ln -sf "${PWD}/.vimrc" "${HOME}/.vimrc"

./scripts/run_installation_step.sh ./install/macos/install-basic.sh
./scripts/run_installation_step.sh ./install/macos/install-git.sh
./scripts/run_installation_step.sh ./install/macos/install-gh.sh
./scripts/run_installation_step.sh ./install/macos/install-zig.sh
./scripts/run_installation_step.sh ./install/macos/install-tmux.sh
./scripts/run_installation_step.sh ./install/macos/install-fish.sh
./scripts/run_installation_step.sh ./install/macos/install-starship.sh
./scripts/run_installation_step.sh ./install/macos/install-kubectl.sh
./scripts/run_installation_step.sh ./install/macos/install-python.sh
./scripts/run_installation_step.sh ./install/macos/install-nvim.sh
./scripts/run_installation_step.sh ./install/macos/install-gcloud.sh
./scripts/run_installation_step.sh ./install/macos/install-bat.sh
./scripts/run_installation_step.sh ./install/macos/install-ruff.sh
