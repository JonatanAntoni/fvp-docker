#!/usr/bin/env bash

SYSTEM="$(uname)"
ARCH="$(uname -m)"
FVP_VERSION=${FVP_VERSION:-"11.22.39"}
FVP_ARCHIVE=${FVP_ARCHIVE:-"avh-fvp-linux-${ARCH}.tar.gz"}
FVP_BASE_URL=${FVP_BASE_URL:-"https://artifacts.keil.arm.com/avh"}
EXITCODE=0

if ! which -s curl; then
    echo "curl is missing on your system"
    EXITCODE=1
fi

if ! which -s tar; then
    echo "tar is missing on your system"
    EXITCODE=1
fi

if ! which -s sha256sum; then
    echo "sha256sum is missing on your system"
    EXITCODE=1
fi

if ! which -s find; then
    echo "find is missing on your system"
    EXITCODE=1
fi

if [ $EXITCODE -gt 0 ]; then
    echo "Some requirements are missing!"
    exit $EXITCODE
fi

pushd "$(dirname "$0")" || exit

if [ ! -f "${FVP_ARCHIVE}" ]; then
    rm -rf "${FVP_ARCHIVE%%.*}"
    find bin -type l -exec rm {} \;
    echo "Downloading ${FVP_BASE_URL}/${FVP_VERSION}/${FVP_ARCHIVE} ..."
    curl -LO "${FVP_BASE_URL}/${FVP_VERSION}/${FVP_ARCHIVE}"
fi

if [ ! -d "${FVP_ARCHIVE%%.*}" ]; then
    mkdir -p "${FVP_ARCHIVE%%.*}"
    tar -xf "${FVP_ARCHIVE}" --strip-components 1 -C "${FVP_ARCHIVE%%.*}"
fi

while IFS= read -r -d '' model; do
    model="$(basename "${model}")"
    if [ ! -L "bin/${model}" ]; then
        ln -s fvp.sh "bin/${model}"
    fi
done < <(find "${FVP_ARCHIVE%%.*}/bin" -depth 1 -type l -print0)

ARCHIVE="avh-fvp-${SYSTEM,,}.tar.gz"
tar -cvzf "${ARCHIVE}" bin build.sh dockerfile

CHECKSUM=$(sha256sum "${ARCHIVE}" | cut -d" " -f 1)

echo "Add the following into your vcpkg json:"
cat <<EOF
    "macos": {
        "install": {
            "untar": "${FVP_BASE_URL}/${FVP_VERSION}/${ARCHIVE}",
            "sha256": "${CHECKSUM}"
        }
    }
EOF
