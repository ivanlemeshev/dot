#!/bin/bash

set -e

source ./scripts/print.sh

LUA_VERSION=5.4.3

print_header "Installing: Lua"

curl -R -O "https://www.lua.org/ftp/lua-${LUA_VERSION}.tar.gz"
tar -zxf "lua-${LUA_VERSION}.tar.gz"

cd "lua-${LUA_VERSION}"
make linux test
sudo make install

cd -
rm -rf "lua-${LUA_VERSION}"
rm "lua-${LUA_VERSION}.tar.gz"

print_header "Checking version: Lua"
lua -v
