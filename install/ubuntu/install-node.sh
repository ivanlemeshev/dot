#!/bin/bash

set -e

source ./scripts/print.sh

node_version="20.16.0"

print_header "Node.js: installing version ${node_version}"
fish -C "mise use -g node@${node_version} && exit"
