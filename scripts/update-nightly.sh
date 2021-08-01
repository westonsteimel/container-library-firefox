#!/bin/bash

set -e

latest_nightly_version=`curl --silent "https://download.mozilla.org/?product=firefox-nightly-latest-ssl&os=linux64&lang=en-US" | sed -nE "s/<a href\=\"https\:\/\/download-installer.cdn.mozilla.net\/pub\/firefox\/nightly\/latest-mozilla-central\/firefox-(.*).en-US.*/\1/p"`

echo "latest nightly version: ${latest_nightly_version}"

sed -ri \
    -e 's/^(ARG VERSION=).*/\1'"\"${latest_nightly_version}\""'/' \
    "nightly/Dockerfile"

git add nightly/Dockerfile
git diff-index --quiet HEAD || git commit --message "updated nightly to version ${latest_nightly_version}"

