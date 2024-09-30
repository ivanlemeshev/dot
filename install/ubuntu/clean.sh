#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"

print_header "System: cleaning up"
sudo apt-get autoremove -y
sudo apt-get autoclean -y
