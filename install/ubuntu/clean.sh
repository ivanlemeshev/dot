#!/bin/bash

# set -e is an option that tells the shell to exit immediately if any command
# exits with a non-zero status.
set -e

echo "--- Cleaning up the system"

sudo apt autoremove -y
sudo apt autoclean -y
