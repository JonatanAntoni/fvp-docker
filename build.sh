#!/usr/bin/env bash

FVP_VERSION=${FVP_VERSION:-"11.22.39"}
FVP_ARCHIVE=${FVP_ARCHIVE:-"avh-fvp-linux-$(uname -m).tar.gz"}
FVP_BASE_URL=${FVP_BASE_URL:-"https://artifacts.keil.arm.com/avh"}
EXITCODE=0

if ! which -s docker; then
    echo "docker is missing on your system"
    EXITCODE=1
fi

if ! docker info >/dev/null; then
    echo "docker daemon not responding"
    EXITCODE=1
fi

if [ ! -d ~/.armlm ]; then
    echo "No Arm license cache found at ~/.armlm"
    echo "Activate Arm user based license."
    echo "The community license can be activates with:"
    echo "armlm --server https://mdk-preview.keil.arm.com --product KEMDK-COM0"
    EXITCODE=1
fi 

if [ $EXITCODE -gt 0 ]; then
    echo "Some requirements are missing!"
    exit $EXITCODE
fi

pushd "$(dirname "$0")" || exit

docker build -t "fvp:${FVP_VERSION}" \
    --build-arg FVP_VERSION="${FVP_VERSION}" \
    --build-arg FVP_ARCHIVE="${FVP_ARCHIVE}" \
    --build-arg FVP_BASE_URL="${FVP_BASE_URL}" \
    --build-arg USERNAME="$(whoami)" \
    --build-arg USERID="$(id -u)" \
    "$@" .
