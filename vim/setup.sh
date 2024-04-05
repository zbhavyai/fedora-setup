#!/bin/bash
# Author        : github.com/zbhavyai
# Purpose       : Setup vimrc


SCRIPT_DIR="$(dirname "$0")"
CONFIG_FILE="${SCRIPT_DIR}/.vimrc"

setup_config() {
    printf '[INFO] Setting up .vimrc: %s\n' "${CONFIG_FILE}"
    cp -p "${CONFIG_FILE}" "${HOME}/"

    printf "\n"
}


main() {
    setup_config
}

main
