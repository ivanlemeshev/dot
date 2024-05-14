#!/bin/bash

set -e

source ./scripts/print.sh

print_header "Updating: system"
sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y
sudo apt autoclean -y
