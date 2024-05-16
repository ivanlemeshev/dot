#!/bin/bash

set -e

source ./scripts/print.sh

print_header "Installing: lazygit"
/usr/local/go/bin/go install github.com/jesseduffield/lazygit@latest
