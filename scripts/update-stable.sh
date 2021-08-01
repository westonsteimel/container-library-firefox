#!/bin/bash

set -e

latest_stable_version=`curl --silent "https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US" | sed -nE "s/<a href\=\"https\:\/\/download-installer.cdn.mozilla.net\/pub\/firefox\/releases\/(.*)\/linux.*/\1/p"`

echo "latest stable version: ${latest_stable_version}"

sed -ri \
    -e 's/^(ARG VERSION=).*/\1'"\"${latest_stable_version}\""'/' \
    "stable/Dockerfile"

git add stable/Dockerfile
git diff-index --quiet HEAD || git commit --message "updated stable to version ${latest_stable_version}"

