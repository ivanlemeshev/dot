#!/bin/bash

set -e

source ./scripts/print.sh

# https://github.com/jdx/mise
print_header "Installing: mise"
brew install mise
