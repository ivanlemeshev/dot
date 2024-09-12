#!/bin/bash

set -e

source scripts/print.sh
source scripts/prompt.sh

print_header "Installing: kubectl"
brew install kubectl

print_header "Linking: kubectl"
brew link kubernetes-cli
