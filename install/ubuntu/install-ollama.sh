#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"

print_header "Ollama: installing"
curl -fsSL https://ollama.com/install.sh | sh
