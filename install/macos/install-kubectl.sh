#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"

print_header "Installing: kubectl"
brew install kubectl

print_header "Linking: kubectl"
brew link kubernetes-cli
