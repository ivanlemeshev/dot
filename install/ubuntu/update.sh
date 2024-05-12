#!/bin/bash

# set -e is an option that tells the shell to exit immediately if any command
# exits with a non-zero status.
set -e

echo "--- Upgrade the system packages"

sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y
sudo apt autoclean -y
