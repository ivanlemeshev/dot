#!/bin/bash

set -e

# The -s option tells ln to create a symbolic link.
# The -f option tells ln to replace the file at the target location if it
# already exists.
ln -sf "${PWD}/.wezterm.lua" "${HOME}/.wezterm.lua"
ln -sf "${PWD}/.vimrc" "${HOME}/.vimrc"

./scripts/run_installation_step.sh ./install/ubuntu/update.sh
./scripts/run_installation_step.sh ./install/ubuntu/install-basic.sh
./scripts/run_installation_step.sh ./install/ubuntu/install-git.sh
./scripts/run_installation_step.sh ./install/ubuntu/install-asdf.sh
./scripts/run_installation_step.sh ./install/ubuntu/install-bat.sh
./scripts/run_installation_step.sh ./install/ubuntu/install-vivid.sh
./scripts/run_installation_step.sh ./install/ubuntu/install-nerd-font.sh
./scripts/run_installation_step.sh ./install/ubuntu/install-tmux.sh
./scripts/run_installation_step.sh ./install/ubuntu/install-starship.sh
./scripts/run_installation_step.sh ./install/ubuntu/install-fish.sh
./scripts/run_installation_step.sh ./install/ubuntu/install-bottom.sh
./scripts/run_installation_step.sh ./install/ubuntu/install-go.sh
./scripts/run_installation_step.sh ./install/ubuntu/install-zig.sh
./scripts/run_installation_step.sh ./install/ubuntu/install-python.sh
./scripts/run_installation_step.sh ./install/ubuntu/install-node.sh
./scripts/run_installation_step.sh ./install/ubuntu/install-lua.sh
./scripts/run_installation_step.sh ./install/ubuntu/install-rust.sh
./scripts/run_installation_step.sh ./install/ubuntu/install-gh.sh
./scripts/run_installation_step.sh ./install/ubuntu/install-nvim.sh
./scripts/run_installation_step.sh ./install/ubuntu/install-yt-dlp.sh
./scripts/run_installation_step.sh ./install/ubuntu/clean.sh

exec fish -l
