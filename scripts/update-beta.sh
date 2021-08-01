#!/bin/bash

set -e

latest_beta_version=`curl --silent "https://download.mozilla.org/?product=firefox-beta-latest-ssl&os=linux64&lang=en-US" | sed -nE "s/<a href\=\"https\:\/\/download-installer.cdn.mozilla.net\/pub\/firefox\/releases\/(.*)\/linux.*/\1/p"`

echo "latest beta version: ${latest_beta_version}"

sed -ri \
    -e 's/^(ARG VERSION=).*/\1'"\"${latest_beta_version}\""'/' \
    "beta/Dockerfile"

git add beta/Dockerfile
git diff-index --quiet HEAD || git commit --message "updated beta to version ${latest_beta_version}"

