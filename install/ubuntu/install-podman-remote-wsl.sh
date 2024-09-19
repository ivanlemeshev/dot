#!/bin/bash

# See: https://podman-desktop.io/docs/podman/accessing-podman-from-another-wsl-instance

set -e

source ./scripts/print.sh

PODMAN_REMOTE_VERSION=5.2.2
PODMAN_REMOTE_ARCHIVE=podman-remote-static-linux_amd64.tar.gz
PODMAN_REMOTE_INSTALLATION_PATH=/usr/local

print_header "Installing: Podman Remote"
wget "https://github.com/containers/podman/releases/download/v${PODMAN_REMOTE_VERSION}/${PODMAN_REMOTE_ARCHIVE}"
[[ -f "${PODMAN_REMOTE_INSTALLATION_PATH}/bin/podman" ]] && sudo rm "${PODMAN_REMOTE_INSTALLATION_PATH}/bin/podman"
sudo tar -C "${PODMAN_REMOTE_INSTALLATION_PATH}" -xzf "${PODMAN_REMOTE_ARCHIVE}"
sudo mv "${PODMAN_REMOTE_INSTALLATION_PATH}/bin/podman-remote-static-linux_amd64" "${PODMAN_REMOTE_INSTALLATION_PATH}/bin/podman"
rm "${PODMAN_REMOTE_ARCHIVE}"

podman system connection add --default podman-machine-default-root unix:///mnt/wsl/podman-sockets/podman-machine-default/podman-root.sock
sudo usermod --append --groups 10 $(whoami)
