#!/bin/bash

set -e

# The -s option tells ln to create a symbolic link.
# The -f option tells ln to replace the file at the target location if it
# already exists.
ln -sf "${PWD}/.wezterm.lua" "${HOME}/.wezterm.lua"

# ./install/ubuntu/update.sh
# ./install/ubuntu/install-basic.sh
./install/ubuntu/install-git.sh
./install/ubuntu/install-tmux.sh
# ./install/ubuntu/install-bat.sh
# ./install/ubuntu/install-bottom.sh
# ./install/ubuntu/install-vivid.sh
# ./install/ubuntu/install-nerd-font.sh
# ./install/ubuntu/install-gh.sh
# ./install/ubuntu/install-starship.sh
# ./install/ubuntu/install-mise.sh
# ./install/ubuntu/install-fish.sh
# ./install/ubuntu/install-go.sh
# ./install/ubuntu/install-zig.sh
# ./install/ubuntu/install-python.sh
# ./install/ubuntu/install-lua.sh
# ./install/ubuntu/install-luarocks.sh
# ./install/ubuntu/install-lazygit.sh
# ./install/ubuntu/install-glow.sh
# ./install/ubuntu/install-nvim.sh
# ./install/ubuntu/install-rust.sh
# ./install/ubuntu/clean.sh

# exec fish -l
