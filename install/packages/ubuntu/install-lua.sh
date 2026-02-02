#!/bin/bash

# Enable strict error handling
# -e: Exit immediately if a command exits with a non-zero status.
# -u: Treat unset variables as an error when substituting.
# -o pipefail: Ensures pipes return the exit code of the last command to fail.
set -euo pipefail

# Get script and project paths
SCRIPT_PATH="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "${SCRIPT_PATH}")"
PROJECT_ROOT="$(dirname "$(dirname "$(dirname "$(dirname "${SCRIPT_PATH}")")")")"

source "${PROJECT_ROOT}/lib/print_header.sh"

lua_version=5.4.3

print_header "Lua: installing version ${lua_version}"

curl -R -O "https://www.lua.org/ftp/lua-${lua_version}.tar.gz"
tar -zxf "lua-${lua_version}.tar.gz"

cd "lua-${lua_version}"
make linux test
sudo make install

cd -
rm -rf "lua-${lua_version}"
rm "lua-${lua_version}.tar.gz"

luarocks_version=3.11.1

print_header "Lua: installing LuaRocks version ${luarocks_version}"

curl -R -O "https://luarocks.github.io/luarocks/releases/luarocks-${luarocks_version}.tar.gz"
tar -zxf "luarocks-${luarocks_version}.tar.gz"

cd "luarocks-${luarocks_version}"
./configure --with-lua-include=/usr/local/include
make
sudo make install

cd -
rm -rf "luarocks-${luarocks_version}"
rm "luarocks-${luarocks_version}.tar.gz"
