#!/bin/bash

set -e

source ./scripts/print.sh

NODE_VERSION="20.16.0"

print_header "Installing: Node.js"
mise use -g "node@${NODE_VERSION}"

print_header "Checking version: Node.js"
node -v
