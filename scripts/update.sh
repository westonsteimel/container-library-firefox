#!/bin/bash

set -e

version=`curl --silent "https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US" | sed -nE "s/<a href\=\"https\:\/\/download-installer.cdn.mozilla.net\/pub\/firefox\/releases\/(.*)\/linux.*/\1/p"`

echo "latest stable version: ${version}"

sed -ri \
    -e 's/^(ARG VERSION=).*/\1'"\"${version}\""'/' \
    "stable/Dockerfile"

git add stable/Dockerfile
git diff-index --quiet HEAD || git commit --message "updated stable to version ${version}"

version=`curl --silent "https://download.mozilla.org/?product=firefox-beta-latest-ssl&os=linux64&lang=en-US" | sed -nE "s/<a href\=\"https\:\/\/download-installer.cdn.mozilla.net\/pub\/firefox\/releases\/(.*)\/linux.*/\1/p"`

echo "latest beta version: ${version}"

sed -ri \
    -e 's/^(ARG VERSION=).*/\1'"\"${version}\""'/' \
    "beta/Dockerfile"

git add beta/Dockerfile
git diff-index --quiet HEAD || git commit --message "updated beta to version ${version}"

version=`curl --silent "https://download.mozilla.org/?product=firefox-nightly-latest-ssl&os=linux64&lang=en-US" | sed -nE "s/<a href\=\"https\:\/\/download-installer.cdn.mozilla.net\/pub\/firefox\/nightly\/latest-mozilla-central\/firefox-(.*).en-US.*/\1/p"`

echo "latest nightly version: ${version}"

sed -ri \
    -e 's/^(ARG VERSION=).*/\1'"\"${version}\""'/' \
    "nightly/Dockerfile"

git add nightly/Dockerfile
git diff-index --quiet HEAD || git commit --message "updated nightly to version ${version}"
