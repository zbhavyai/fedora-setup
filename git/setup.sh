#!/bin/bash
#
# author        : bhavyai
# description   : setup gitconfig

SCRIPT_DIR="$(dirname "$0")"
CONFIG_FILE_HOME="${SCRIPT_DIR}/.gitconfig"
CONFIG_FILE_WORK="${SCRIPT_DIR}/.gitconfig-work"

setup_config() {
    printf '[INFO] Setting up gitconfig: %s\n' "${CONFIG_FILE_HOME}"
    cp -p "${CONFIG_FILE_HOME}" "${HOME}/"
    
    printf '[INFO] Setting up gitconfig: %s\n' "${CONFIG_FILE_WORK}"
    cp -p "${CONFIG_FILE_WORK}" "${HOME}/"

    printf "\n\n"
}

main() {
    setup_config
}

main
