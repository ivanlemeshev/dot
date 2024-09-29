#!/bin/bash

set -e

source ./scripts/print.sh

print_header "Installing: Basic packages"

packages=(
	# Essential tools
	"curl"    # A tool for transferring data from or to a server using URLs.
	"wget"    # A tool for downloading files from the Internet.
	"vim"     # A programmer's text editor.
	"htop"    # An interactive process viewer.
	"ripgrep" # A line-oriented search tool that recursively searches your current directory for a regex pattern.
	"fd-find" # A simple, fast and user-friendly alternative to 'find'.
	"fzf"     # A command-line fuzzy finder.
	"tmux"    # A terminal multiplexer.
	"unzip"   # A tool for extracting files from ZIP archives.
	"ffmpeg"  # A complete, cross-platform solution to record, convert and stream audio and video.

	# Development tools
	"make"              # A tool for controlling the generation of executables and other non-source files of a program from the program's source files.
	"gcc"               # The GNU Compiler Collection.
	"protobuf-compiler" # A compiler for Google's Protocol Buffers.

	# Development libraries
	"build-essential"            # Contains an essential package for compiling software.
	"software-properties-common" # Contains add-apt-repository command.
	"libssl-dev"                 # Contains development files for OpenSSL cryptographic library.
	"zlib1g-dev"                 # Contains development files for zlib compression library.
	"libbz2-dev"                 # Contains development files for bzip2 compression library.
	"libreadline-dev"            # Contains development files for GNU readline library.
	"libsqlite3-dev"             # Contains development files for SQLite3 database library.
	"llvm"                       # Contains development files for LLVM compiler infrastructure.
	"xz-utils"                   # Contains development files for XZ compression library.
	"tk-dev"                     # Contains development files for Tk toolkit.
	"libxml2-dev"                # Contains development files for XML C parser and toolkit.
	"libxmlsec1-dev"             # Contains development files for XML security library.
	"libffi-dev"                 # Contains development files for Foreign Function Interface library.
	"liblzma-dev"                # Contains development files for XZ-format compression library.
)

sudo apt install -y ${packages[*]}
