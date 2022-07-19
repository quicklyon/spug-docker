#!/bin/bash

set -Eeuo pipefail

REPO_URL="https://api.github.com/repos/openspug/spug/releases/latest"

LATEST_VER=$( curl -s -L $REPO_URL | jq -r .tag_name | sed 's/^v//')
CURRENT_VER=$( cat VERSION)

if [ "$LATEST_VER" != "$CURRENT_VER" ];then
  echo $LATEST_VER > VERSION
  echo "Spug new version was detected. Please rebuild the image."
else
  echo "$CURRENT_VER is the latest version."
fi
