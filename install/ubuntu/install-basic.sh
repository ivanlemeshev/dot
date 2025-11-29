#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"

print_header "System: installing basic packages"

packages=(
  "ansible"                    # A tool for automating software provisioning, configuration management, and application deployment.
  "build-essential"            # A package for building software from source.
  "clang-format"               # A tool to format C, C++ and Objective-C code.
  "clangd"                     # A language server for C, C++ and Objective-C.
  "curl"                       # A tool for transferring data from or to a server using URLs.
  "direnv"                     # A tool for managing environment variables based on the current directory.
  "fd-find"                    # A simple, fast and user-friendly alternative to find.
  "ffmpeg"                     # A complete, cross-platform solution to record, convert and stream audio and video.
  "fontconfig"                 # A library for configuring and customizing font access.
  "fzf"                        # A command-line fuzzy finder.
  "gcc"                        # The GNU Compiler Collection, a set of compilers for various programming languages.
  "gdb"                        # The GNU Debugger, a powerful debugger for C/C++ and other languages.
  "htop"                       # An interactive process viewer.
  "python3-pip"                # A tool for installing Python packages.
  "python3-venv"               # A tool for creating isolated Python environments.
  "ripgrep"                    # A line-oriented search tool that recursively searches your current directory for a regex pattern.
  "software-properties-common" # A common package for adding PPA repositories.
  "strace"                     # A diagnostic, debugging and instructional userspace utility for Linux.
  "tree"                       # A utility for displaying directory tree structures.
  "unzip"                      # A utility for extracting, testing and viewing the contents of ZIP archives.
  "vim"                        # A programmer's text editor.
  "wget"                       # A tool for downloading files from the Internet.
  "wslu"                       # A collection of utilities for WSL (Windows Subsystem for Linux).
  "xz-utils"                   # A set of tools for working with xz compressed files.
)

sudo apt-get install -y ${packages[*]}
