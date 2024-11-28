#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"

# https://github.com/jdx/mise
print_header "Installing: mise"
brew install mise
