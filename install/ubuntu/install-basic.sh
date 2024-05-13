#!/bin/bash

# set -e is an option that tells the shell to exit immediately if any command
# exits with a non-zero status.
set -e

echo "--- Installing basic packages"

sudo apt install -y curl wget git htop vim make unzip gcc ripgrep

sudo apt autoremove -y
sudo apt autoclean -y
