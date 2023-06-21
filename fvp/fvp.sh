#!/usr/bin/env bash

MODEL=$(basename "$0")

docker run --platform linux/amd64 --mount "type=bind,src=$HOME,dst=$HOME" -w "$(pwd)" fvp "${MODEL}" "$@"

exit
