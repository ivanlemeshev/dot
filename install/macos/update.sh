#!/bin/bash

set -e

source ./scripts/print.sh

print_header "Updating: system"
brew upgrade
