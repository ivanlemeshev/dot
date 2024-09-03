#!/bin/bash

set -e

source ./scripts/print.sh

print_header "Installing: Zig"

CURRENT_ARCH=$(uname -i)
print_header "Current arch: ${CURRENT_ARCH}"

ZIG_VERSION=0.13.0
ZIG_ARCHIVE="zig-linux-${CURRENT_ARCH}-${ZIG_VERSION}.tar.xz"
ZIG_INSTALLATION_PATH=/usr/local

print_header "Downloading Zig ${ZIG_VERSION}"
curl -O "https://ziglang.org/download/${ZIG_VERSION}/${ZIG_ARCHIVE}"

print_header "Extracting Zig ${ZIG_VERSION}"
[[ -d "${ZIG_INSTALLATION_PATH}/zig" ]] && sudo rm -rf "${ZIG_INSTALLATION_PATH}/zig"
sudo tar -C "${ZIG_INSTALLATION_PATH}" -xf "${ZIG_ARCHIVE}"
sudo mv "${ZIG_INSTALLATION_PATH}/zig-linux-${CURRENT_ARCH}-${ZIG_VERSION}" "${ZIG_INSTALLATION_PATH}/zig"

print_header "Cleaning up"
rm "${ZIG_ARCHIVE}"
