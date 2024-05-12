#!/bin/bash

echo "--- Installing tmux"

sudo apt install -y tmux

# Install tmux plugin manager https://github.com/tmux-plugins/tpm
if [ ! -d ${HOME}/.tmux/plugins/tpm ]; then
  git clone https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm
fi

cd ${HOME}/.tmux/plugins/tpm
git pull origin master
cd -

# Create a symbolic link to the tmux configuration file.
ln -sf "${PWD}/.tmux.conf" "${HOME}/.tmux.conf"
