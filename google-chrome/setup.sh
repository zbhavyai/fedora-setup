#!/bin/bash
# Author        : github.com/zbhavyai
# Purpose       : Install Google Chrome


SCRIPT_DIR="$(dirname "$0")"
PKG_FILE="${HOME}/Downloads/google-chrome-stable_current_x86_64.rpm"

install_packages() {
    wget --output-document="${PKG_FILE}" https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
    sudo rpm --install "${PKG_FILE}"
    rm "${PKG_FILE}"
}


main() {
    install_packages
}

main
