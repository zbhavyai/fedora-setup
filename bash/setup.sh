#!/bin/bash
# Author        : github.com/zbhavyai
# Purpose       : Setup bashrc


SCRIPT_DIR="$(dirname "$0")"
CONFIG_FILE="${SCRIPT_DIR}/.bashrc"

setup_config() {
    printf '[INFO] Setting up .bashrc: %s\n' "${CONFIG_FILE}"
    cp -p "${CONFIG_FILE}" "${HOME}/"

    printf "\n"
}


main() {
    setup_config
}

main
