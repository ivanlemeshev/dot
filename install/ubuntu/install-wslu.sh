#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"

print_header "wslu: installing"

sudo add-apt-repository -y ppa:wslutilities/wslu
sudo apt-get update
sudo apt-get install wslu
