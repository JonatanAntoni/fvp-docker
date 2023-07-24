#!/usr/bin/env bash

FVP_VERSION="11.22"

ARTIFACTORY_URL="${ARTIFACTORY_URL:-artifactory.eu02.arm.com}"

pushd "$(dirname "$0")" || exit

docker build -t fvp:${FVP_VERSION} -t fvp:latest --platform linux/amd64 \
    --build-arg FVP_VERSION="${FVP_VERSION}" \
    --build-arg ARTIFACTORY_API_KEY="${ARTIFACTORY_API_KEY}" \
    --build-arg ARTIFACTORY_URL="${ARTIFACTORY_URL}" \
    --build-arg USERNAME="$(whoami)" \
    --build-arg USERID="$(id -u)" \
    "$@" .

exit
