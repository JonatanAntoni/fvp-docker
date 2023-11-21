#!/usr/bin/env bash

FVP_VERSION=${FVP_VERSION:-"11.22.39"}
FVP_ARCHIVE=${FVP_ARCHIVE:-"avh-fvp-linux-$(uname -m).tar.gz"}
FVP_BASE_URL=${FVP_BASE_URL:-"https://artifacts.keil.arm.com/avh"}

pushd "$(dirname "$0")" || exit

docker build -t "fvp:${FVP_VERSION}" \
    --build-arg FVP_VERSION="${FVP_VERSION}" \
    --build-arg FVP_ARCHIVE="${FVP_ARCHIVE}" \
    --build-arg FVP_BASE_URL="${FVP_BASE_URL}" \
    --build-arg USERNAME="$(whoami)" \
    --build-arg USERID="$(id -u)" \
    "$@" .
