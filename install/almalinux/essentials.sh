#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

if [[ -f "$PROJECT_ROOT/config.env" ]]; then
  source "$PROJECT_ROOT/config.env"
fi

print_section "Enabling EPEL and CRB"
sudo dnf install -y epel-release dnf-plugins-core
sudo dnf config-manager --set-enabled crb

print_section "Installing essential packages"
packages=(
  ansible-core
  clang
  clang-tools-extra
  cmake
  curl
  fd-find
  ffmpeg-free
  fontconfig
  gcc
  gcc-c++
  gdb
  htop
  jq
  less
  make
  libjpeg-turbo-devel
  pandoc
  python3
  python3-pip
  ripgrep
  ShellCheck
  strace
  tree
  unzip
  wget
  xz
  xxd
  zstd
)

sudo dnf install -y "${packages[@]}"

if [[ -n "${MACHINE_NAME:-}" ]]; then
  if [[ ! "$MACHINE_NAME" =~ ^[[:alnum:]][[:alnum:].-]*$ ]]; then
    log_error "Invalid machine name: $MACHINE_NAME"
    exit 1
  fi
  if [[ ! -f /.dockerenv && ! -f /run/.containerenv ]]; then
    sudo hostnamectl set-hostname "$MACHINE_NAME"
  fi
fi

if [[ -n "${TIMEZONE:-}" ]]; then
  if [[ ! -e "/usr/share/zoneinfo/$TIMEZONE" ]]; then
    log_error "Unknown timezone: $TIMEZONE"
    exit 1
  fi
  if [[ ! -f /.dockerenv && ! -f /run/.containerenv ]]; then
    sudo timedatectl set-timezone "$TIMEZONE"
  fi
fi
