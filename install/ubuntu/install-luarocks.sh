#!/bin/bash

set -e

source ./scripts/print.sh

LUAROCKS_VERSION=3.11.1

print_header "Installing: LuaRocks"

curl -R -O "https://luarocks.github.io/luarocks/releases/luarocks-${LUAROCKS_VERSION}.tar.gz"
tar -zxf "luarocks-${LUAROCKS_VERSION}.tar.gz"

cd "luarocks-${LUAROCKS_VERSION}"
./configure --with-lua-include=/usr/local/include
make
sudo make install

cd -
rm -rf "luarocks-${LUAROCKS_VERSION}"
rm "luarocks-${LUAROCKS_VERSION}.tar.gz"

print_header "Checking version: LuaRocks"
luarocks --version
