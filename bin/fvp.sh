#!/usr/bin/env bash

MODEL=$(basename "$0")
ARMLM_CACHED_LICENSES_LOCATION="${ARMLM_CACHED_LICENSES_LOCATION:-$HOME/.armlm}"

docker run --platform linux/amd64 --mount "type=bind,src=$ARMLM_CACHED_LICENSES_LOCATION,dst=/home/$(whoami)/.armlm" --mount "type=bind,src=$HOME,dst=$HOME" -w "$(pwd)" fvp "${MODEL}" "$@"

exit
