#!/bin/bash

set -e

export DOCKER_CLI_EXPERIMENTAL="enabled"

DOCKER_BUILD_CONTEXT="${DOCKER_BUILD_CONTEXT:-.}"
DOCKER_FILE="${DOCKER_FILE:-${DOCKER_BUILD_CONTEXT}/Dockerfile}"

if [[ -z "$DOCKER_TAGS" ]]; then
    echo "Set the DOCKER_TAGS environment variable."
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

if [[ -z "$GHCR_TOKEN" ]]; then
    echo "Set the GHCR_TOKEN environment variable."
    exit 1
fi

if [[ -z "$QUAY_USERNAME" ]]; then
    echo "Set the QUAY_USERNAME environment variable."
    exit 1
fi

if [[ -z "$QUAY_PASSWORD" ]]; then
    echo "Set the QUAY_PASSWORD environment variable."
    exit 1
fi

if [[ -z "$GITHUB_REPOSITORY" ]]; then
    echo "Set the GITHUB_REPOSITORY environment variable."
    exit 1
fi

GITHUB_OWNER=$(echo "${GITHUB_REPOSITORY}" | cut -d'/' -f1)

if [[ -z "$DOCKER_IMAGE_VERSION" ]]; then
    echo "Set the DOCKER_IMAGE_VERSION environment variable."
    exit 1
fi

export SOURCE="https://github.com/${GITHUB_REPOSITORY}"
platforms="linux/amd64"

# Login to Docker Hub
echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin "docker.io"
# Login to GitHub Container registry
echo "${GHCR_TOKEN}" | docker login -u "${GITHUB_OWNER}" --password-stdin "ghcr.io"
# Login to Quay
echo "${QUAY_PASSWORD}" | docker login -u "${QUAY_USERNAME}" --password-stdin "quay.io"

docker_base_repo="docker.io/${DOCKER_USERNAME}/firefox"
ghcr_base_repo="ghcr.io/${GITHUB_OWNER}/firefox"
quay_base_repo="quay.io/${QUAY_USERNAME}/firefox"

IFS=',' read -ra TAGS <<< "$DOCKER_TAGS"
for tag in "${TAGS[@]}"; do
    tag_command="${tag_command} --tag ${docker_base_repo}:${tag} --tag ${ghcr_base_repo}:${tag} --tag ${quay_base_repo}:${tag}"
done

created_date=`date --utc --rfc-3339=seconds`
docker buildx build --platform "${platforms}" \
    --label "org.opencontainers.image.source=${SOURCE}" \
    --label "org.opencontainers.image.created=${created_date}" \
    --output "type=image,push=true" \
    ${tag_command} \
    --file "${DOCKER_FILE}" \
    "${DOCKER_BUILD_CONTEXT}"

docker logout
