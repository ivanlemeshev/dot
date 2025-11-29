#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"

print_header "Copilot CLI: installing"
npm install -g @github/copilot

print_header "Gemini CLI: installing"
npm install -g @google/gemini-cli
