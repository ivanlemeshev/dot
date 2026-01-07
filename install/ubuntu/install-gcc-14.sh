#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"

print_header "GCC 14: installing"

# Install GCC 14 on Ubuntu
sudo apt update
sudo apt install gcc-14 g++-14

# Set GCC 14 as the default compiler and also keep GCC 13 as an option
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-13 13 --slave /usr/bin/g++ g++ /usr/bin/g++-13
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-14 14 --slave /usr/bin/g++ g++ /usr/bin/g++-14
gcc --version
