#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"

node_version="22.14.0"

print_header "Node.js: installing version ${node_version}"
fish -C "mise use -g node@${node_version} && exit"
