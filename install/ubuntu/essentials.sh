#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/print.sh"
source "$PROJECT_ROOT/lib/prompt.sh"

if [[ -f "$PROJECT_ROOT/config.env" ]]; then
  source "$PROJECT_ROOT/config.env"
fi

print_section "Installing essential packages"

packages=(
  # A tool for automating software provisioning, configuration management, and
  # application deployment.
  "ansible"

  # A package for building software from source.
  "build-essential"

  # A tool to format C, C++ and Objective-C code.
  "clang-format"

  # A language server for C, C++ and Objective-C.
  "clangd"

  # A tool for transferring data from or to a server using URLs.
  "curl"

  # A tool for managing environment variables based on the current
  # directory.
  "direnv"

  # A simple, fast and user-friendly alternative to find.
  "fd-find"

  # A complete, cross-platform solution to record, convert and stream audio and
  # video.
  "ffmpeg"

  # A library for configuring and customizing font access.
  "fontconfig"

  # A command-line fuzzy finder.
  "fzf"

  # The GNU Compiler Collection, a set of compilers for various programming
  # languages.
  "gcc"

  # The GNU Debugger, a powerful debugger for C/C++ and other languages.
  "gdb"

  # An interactive process viewer.
  "htop"

  # A terminal pager program used to view text files and command output.
  "less"

  # A tool for installing Python packages.
  "python3-pip"

  # A tool for creating isolated Python environments.
  "python3-venv"

  # A line-oriented search tool that recursively searches your current
  # directory for a regex pattern.
  "ripgrep"

  # A common package for adding PPA repositories.
  "software-properties-common"

  # A diagnostic, debugging and instructional userspace utility for Linux.
  "strace"

  # A utility for displaying directory tree structures.
  "tree"

  # A utility for extracting, testing and viewing the contents of ZIP archives.
  "unzip"

  # A tool for downloading files from the Internet.
  "wget"

  # A collection of utilities for WSL (Windows Subsystem for Linux).
  "wslu"

  # A set of tools for working with xz compressed files.
  "xz-utils"

  # A fast and efficient compression tool based on Zstandard.
  "zstd"
)

# Set timezone non-interactively to avoid prompts during package installation.
# Default to UTC if not set in config.env or environment variables.
export DEBIAN_FRONTEND=noninteractive

if [[ -f "$PROJECT_ROOT/config.env" ]]; then
  source "$PROJECT_ROOT/config.env"
fi

if [[ -z "${TIMEZONE:-}" ]]; then
  TIMEZONE="UTC"
fi

# Link the appropriate timezone file to /etc/localtime and set /etc/timezone
# to ensure the system uses the correct timezone without prompting the user.
sudo ln -snf /usr/share/zoneinfo/"$TIMEZONE" /etc/localtime
echo "$TIMEZONE" | sudo tee /etc/timezone >/dev/null

sudo apt-get install -y "${packages[@]}"
