#!/bin/bash
# Author        : github.com/zbhavyai
# Purpose       : Setup ssh


SCRIPT_DIR="$(dirname "$0")"
CONFIG_FILE="${SCRIPT_DIR}/config"

setup_config() {
    printf '[INFO] Setting up ssh config: %s\n' "${CONFIG_FILE}"

    mkdir -p "${HOME}/.ssh"
    chmod 700 "${HOME}/.ssh"

    cp -p "${CONFIG_FILE}" "${HOME}/.ssh/"
    chmod 600 "${HOME}/.ssh/config"

    printf "\n"
}


main() {
    setup_config
}

main
