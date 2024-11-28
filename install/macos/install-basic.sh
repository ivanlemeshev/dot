#!/bin/bash

set -e

source ./scripts/print.sh

print_header "Installing: Homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

print_header "Installing: basic packages"
brew install \
	openssl \
	readline \
	sqlite3 \
	xz \
	zlib \
	tcl-tk \
	vivid \
	tree \
	fd \
	fzf \
	bottom \
	go \
	node \
	lazygit
