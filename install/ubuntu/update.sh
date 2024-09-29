#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"

print_header "Updating the system"
sudo apt-get update
sudo apt-get upgrade -y
