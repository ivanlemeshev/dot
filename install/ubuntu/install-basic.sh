#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"

print_header "Installing basic packages"

packages=(
	# Essential tools
	"curl"       # A tool for transferring data from or to a server using URLs.
	"wget"       # A tool for downloading files from the Internet.
	"vim"        # A programmer's text editor.
	"htop"       # An interactive process viewer.
	"xz-utils"   # A set of tools for working with xz compressed files.
	"fontconfig" # A library for configuring and customizing font access.
)

sudo apt-get install -y ${packages[*]}
