#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"

protocurl_version=1.20.0
protocurl_archive=protocurl_${protocurl_version}_darwin_arm64.zip
protocurl_installation_path=/opt/protocurl

print_header "protocurl: installing"
curl -LO https://github.com/qaware/protocurl/releases/download/v${protocurl_version}/${protocurl_archive}
sudo rm -rf ${protocurl_installation_path}
sudo unzip ${protocurl_archive} -d ${protocurl_installation_path}
rm ${protocurl_archive}
