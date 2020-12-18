#!/bin/bash

set -e

export DOCKER_CLI_EXPERIMENTAL="enabled"
DOCKER_REGISTRY="${DOCKER_REGISTRY:-docker.io}"
DOCKER_BUILD_CONTEXT="${DOCKER_BUILD_CONTEXT:-.}"
DOCKER_FILE="${DOCKER_FILE:-${DOCKER_BUILD_CONTEXT}/Dockerfile}"

if [[ -z "$DOCKER_TAGS" ]]; then
    echo "Set the DOCKER_TAGS environment variable."
    exit 1
fi

if [[ -z "$DOCKER_REPOSITORY" ]]; then
    echo "Set the DOCKER_REPOSITORY environment variable."
    exit 1
fi

if [[ -z "$DOCKER_USERNAME" ]]; then
    echo "Set the DOCKER_USERNAME environment variable."
    exit 1
fi

if [[ -z "$DOCKER_PASSWORD" ]]; then
    echo "Set the DOCKER_PASSWORD environment variable."
    exit 1
fi

if [[ -z "$GITHUB_REPOSITORY" ]]; then
    echo "Set the GITHUB_REPOSITORY environment variable."
    exit 1
fi

if [[ -z "$GITHUB_SHA" ]]; then
    echo "Set the GITHUB_SHA environment variable."
    exit 1
fi

if [[ -z "$DOCKER_IMAGE_VERSION" ]]; then
    echo "Set the DOCKER_IMAGE_VERSION environment variable."
    exit 1
fi

export BASE_NAME="${DOCKER_REGISTRY}/${DOCKER_USERNAME}/${DOCKER_REPOSITORY}"
export SOURCE="https://github.com/${GITHUB_REPOSITORY}"
export REVISION="${GITHUB_SHA}"
export CREATED="`date --utc --rfc-3339=seconds`"
export VERSION="${DOCKER_IMAGE_VERSION}"

echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin "${DOCKER_REGISTRY}"

IFS=',' read -ra TAGS <<< "$DOCKER_TAGS"
for tag in "${TAGS[@]}"; do
    docker buildx build --platform "linux/amd64" \
        --build-arg SOURCE \
        --build-arg REVISION \
        --build-arg CREATED \
        --build-arg VERSION \
        --output "type=image,push=true" \
        --tag "${BASE_NAME}:${tag}" \
        --file "${DOCKER_FILE}" \
        "${DOCKER_BUILD_CONTEXT}"
done

docker logout
