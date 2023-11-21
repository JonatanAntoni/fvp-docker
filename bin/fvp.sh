#!/usr/bin/env bash

FVP_VERSION=${FVP_VERSION:-"11.22.39"}
MODEL=$(basename "$0")
ARMLM_CACHED_LICENSES_LOCATION="${ARMLM_CACHED_LICENSES_LOCATION:-$HOME/.armlm}"

FLAGS=("$@")
PORTS=()
if [[ "${FLAGS[*]}" =~ "-I" || "${FLAGS[*]}" =~ "--iris-server" ]]; then
    PORTS+=("-p" "7100:7100")
    if [[ ! "${FLAGS[*]}" =~ "--print-port-number" && ! "${FLAGS[*]}" =~ "-p" ]]; then
        FLAGS+=("--print-port-number")
    fi
    if [[ ! "${FLAGS[*]}" =~ "--iris-allow-remote" && ! "${FLAGS[*]}" =~ "-A" ]]; then
        FLAGS+=("--iris-allow-remote")
    fi
fi

if ! docker image inspect "fvp:${FVP_VERSION}" >/dev/null 2>&1; then
    "$(dirname "$0")/../build.sh"
fi

docker run "${PORTS[@]}" --mount "type=bind,src=$ARMLM_CACHED_LICENSES_LOCATION,dst=/home/$(whoami)/.armlm" --mount "type=bind,src=$HOME,dst=$HOME" -w "$(pwd)" "fvp:${FVP_VERSION}" "${MODEL}" "${FLAGS[@]}"

exit
