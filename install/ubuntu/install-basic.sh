#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"

print_header "System: installing basic packages"

packages=(
	"curl"                       # A tool for transferring data from or to a server using URLs.
	"wget"                       # A tool for downloading files from the Internet.
	"vim"                        # A programmer's text editor.
	"htop"                       # An interactive process viewer.
	"unzip"                      # A utility for extracting, testing and viewing the contents of ZIP archives.
	"xz-utils"                   # A set of tools for working with xz compressed files.
	"fontconfig"                 # A library for configuring and customizing font access.
	"fzf"                        # A command-line fuzzy finder.
	"fd-find"                    # A simple, fast and user-friendly alternative to find.
	"software-properties-common" # A common package for adding PPA repositories.
	"build-essential"            # A package for building software from source.
)

sudo apt-get install -y ${packages[*]}
