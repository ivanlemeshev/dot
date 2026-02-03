#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/scripts/functions/print_header.sh"

golang_version=1.24.2
golang_archive=go${golang_version}.linux-amd64.tar.gz
golang_installation_path=/usr/local

print_header "Golang: installing"
curl -sO https://dl.google.com/go/${golang_archive}
[[ -d "${golang_installation_path}/go" ]] && sudo rm -rf "${golang_installation_path}/go"
sudo tar -C "${golang_installation_path}" -xzf go${golang_version}.linux-amd64.tar.gz
rm ${golang_archive}

go install github.com/golangci/golangci-lint/v2/cmd/golangci-lint@latest
