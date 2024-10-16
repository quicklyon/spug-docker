#!/bin/bash
#
# Library for managing Easysoft components

[ -n "${EASYSOFT_DEBUG:+1}" ] && set -x

# Constants
DOWNLOAD_URL="https://gitfox.zcorp.cc/_artifacts/ci/raw/runtime"

# Functions

########################
# Download and unpack a Easysoft package
# Globals:
#   OS_NAME
#   OS_ARCH
# Arguments:
#   $1 - component's name
#   $2 - component's version
# Returns:
#   None
#########################
component_unpack() {
    local name="${1:?name is required}"
    local version="${2:?version is required}"
    local base_name="${name}-${version}-${OS_NAME}-${OS_ARCH}"
    local package_sha256=""
    local directory="/"

    echo "Downloading $base_name package"
   	curl -k --remote-name --silent --show-error --fail "${DOWNLOAD_URL}/${name}/${version}/${base_name}.tar.gz"

    if [ -n "$package_sha256" ]; then
        echo "Verifying package integrity"
        echo "$package_sha256  ${base_name}.tar.gz" | sha256sum -c - || exit "$?"
    fi
    tar xzf "${base_name}.tar.gz" --directory "${directory}"
    rm "${base_name}.tar.gz"
}