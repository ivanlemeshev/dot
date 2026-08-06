#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

if [[ -f "$PROJECT_ROOT/config.env" ]]; then
  source "$PROJECT_ROOT/config.env"
fi

print_section "Installing essential packages"

packages=(
  # Automation, provisioning, and configuration management.
  ansible

  # C, C++, and Objective-C compiler.
  clang

  # Clang utilities including clang-format, clang-tidy, and clangd.
  clang-tools-extra

  # Cross-platform build system generator.
  cmake

  # Transfers data using URLs.
  curl

  # Loads directory-specific environment variables.
  direnv

  # Fast alternative to find.
  fd-find

  # Records, converts, and streams audio and video.
  ffmpeg-free

  # Discovers and configures installed fonts.
  fontconfig

  # GNU C compiler.
  gcc

  # GNU C++ compiler.
  gcc-c++

  # GNU debugger.
  gdb

  # Interactive process viewer.
  htop

  # Processes and transforms JSON data.
  jq

  # Terminal pager for text and command output.
  less

  # Build automation utility.
  make

  # JPEG library headers required to build native software.
  libjpeg-turbo-devel

  # Python interpreter and standard library.
  python3

  # Python package installer.
  python3-pip

  # Fast recursive text search.
  ripgrep

  # Traces system calls and signals.
  strace

  # Displays directory structures as a tree.
  tree

  # Extracts ZIP archives.
  unzip

  # Downloads files from the web.
  wget

  # Compresses and extracts XZ archives.
  xz

  # Creates and reverses hexadecimal dumps.
  xxd

  # Fast general-purpose compression utility.
  zstd

  # Adds DNF commands for repositories, COPR, and build dependencies.
  dnf5-plugins
)

log_info "Installing packages:"
printf '%s\n' "${packages[@]}"
sudo dnf install -y "${packages[@]}"

if [[ -n "${TIMEZONE:-}" ]]; then
  if [[ ! -e "/usr/share/zoneinfo/$TIMEZONE" ]]; then
    log_error "Unknown timezone: $TIMEZONE"
    exit 1
  fi
  sudo timedatectl set-timezone "$TIMEZONE"
fi
