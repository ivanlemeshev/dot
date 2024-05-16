#!/bin/bash

set -e

source ./scripts/print.sh

GOLANG_VERSION=1.22.3
GOLANG_ARCHIVE=go${GOLANG_VERSION}.linux-amd64.tar.gz
GOLANG_INSTALLATION_PATH=/usr/local

print_header "Installing: Go"
curl -sO https://dl.google.com/go/${GOLANG_ARCHIVE}
[[ -d "${GOLANG_INSTALLATION_PATH}/go" ]] && sudo rm -rf "${GOLANG_INSTALLATION_PATH}/go"
sudo tar -C "${GOLANG_INSTALLATION_PATH}" -xzf go${GOLANG_VERSION}.linux-amd64.tar.gz
rm ${GOLANG_ARCHIVE}
