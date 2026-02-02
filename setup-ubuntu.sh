#!/bin/bash

# Enable strict error handling
# -e: Exit immediately if a command exits with a non-zero status.
# -u: Treat unset variables as an error when substituting.
# -o pipefail: Ensures pipes return the exit code of the last command to fail.
set -euo pipefail

# The -s option tells ln to create a symbolic link.
# The -f option tells ln to replace the file at the target location if it
# already exists.
ln -sf "${PWD}/config/vim/.vimrc" "${HOME}/.vimrc"

./install/packages/ubuntu/update.sh
./install/packages/ubuntu/install-basic.sh
./install/packages/ubuntu/install-git.sh
./install/packages/ubuntu/install-asdf.sh
./install/packages/ubuntu/install-bat.sh
./install/packages/ubuntu/install-vivid.sh
./install/packages/ubuntu/install-nerd-font.sh
./install/packages/ubuntu/install-tmux.sh
./install/packages/ubuntu/install-starship.sh
./install/packages/ubuntu/install-fish.sh
./install/packages/ubuntu/install-bottom.sh
./install/packages/ubuntu/install-go.sh
./install/packages/ubuntu/install-zig.sh
./install/packages/ubuntu/install-python.sh
./install/packages/ubuntu/install-node.sh
./install/packages/ubuntu/install-lua.sh
./install/packages/ubuntu/install-rust.sh
./install/packages/ubuntu/install-gh.sh
./install/packages/ubuntu/install-nvim.sh
./install/packages/ubuntu/install-yt-dlp.sh
./install/packages/ubuntu/clean.sh

exec fish -l
