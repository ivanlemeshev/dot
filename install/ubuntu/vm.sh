#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing tools for virtualized environment"

log_info "Updating package lists"
sudo apt-get update

log_info "Installing the QEMU/KVM virtualization stack"
# - qemu-kvm: hypervisor with KVM hardware acceleration
# - libvirt-daemon-system: system service managing VMs, networks, and storage
# - libvirt-clients: CLI tools (e.g., virsh) to control libvirt
# - bridge-utils: utilities for creating network bridges for VM networking
# - virtinst: CLI tools to create/install VMs (virt-install)
# - virt-manager: graphical VM manager
sudo apt-get install -y \
  qemu-kvm \
  libvirt-daemon-system \
  libvirt-clients \
  bridge-utils \
  virtinst \
  virt-manager

log_info "Adding current user to libvirt and kvm groups for permissions"
sudo usermod -aG libvirt "$USER"
sudo usermod -aG kvm "$USER"

log_info "Enabling libvirt daemon to start on boot"
sudo systemctl enable libvirtd
