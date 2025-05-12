#!/bin/bash
# Author        : github.com/zbhavyai
# Purpose       : Install macOS like cursors


SCRIPT_DIR="$(dirname "$0")"
ARCHIVE="${HOME}/Downloads/macOS_cursors.tar.xz"

install_packages() {
    wget --quiet --output-document="${ARCHIVE}" https://github.com/ful1e5/apple_cursor/releases/download/v2.0.1/macOS.tar.xz
    mkdir -p "${HOME}/.local/share/icons"
    tar xf "${ARCHIVE}" --directory "${HOME}/.local/share/icons"
    rm -r "${HOME}/.local/share/icons/macOS-White" "${HOME}/.local/share/icons/LICENSE"

    rm "${ARCHIVE}"
}


main() {
    install_packages
}

main
