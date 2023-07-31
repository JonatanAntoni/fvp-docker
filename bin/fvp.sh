#!/usr/bin/env bash

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

docker run --platform linux/amd64 "${PORTS[@]}" --mount "type=bind,src=$ARMLM_CACHED_LICENSES_LOCATION,dst=/home/$(whoami)/.armlm" --mount "type=bind,src=$HOME,dst=$HOME" -w "$(pwd)" fvp "${MODEL}" "${FLAGS[@]}"

exit
