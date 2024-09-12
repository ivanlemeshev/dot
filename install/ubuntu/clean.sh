#!/bin/bash

set -e

source ./scripts/print.sh

print_header "Cleaning up: system"
sudo apt autoremove -y
sudo apt autoclean -y
