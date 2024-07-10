#!/bin/bash

set -e

source ./scripts/print.sh

INSTALLATION_PATH="${HOME}/.local/bin"

# https://github.com/jdx/mise
print_header "Installing: mise"
[[ ! -d "${INSTALLATION_PATH}" ]] && mkdir -p "${INSTALLATION_PATH}"
curl -o "${INSTALLATION_PATH}/mise" https://mise.jdx.dev/mise-latest-linux-x64
chmod +x "${INSTALLATION_PATH}/mise"
