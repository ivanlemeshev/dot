#!/bin/bash

echo "--- Installing basic packages"

sudo apt install -y curl wget git htop vim tmux make unzip gcc ripgrep

sudo apt autoremove -y
sudo apt autoclean -y
