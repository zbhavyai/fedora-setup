#!/bin/bash
# Author        : github.com/zbhavyai
# Purpose       : Setup konsole


SCRIPT_DIR="$(dirname "$0")"
CONFIG_PROFILES="${SCRIPT_DIR}/BG-PROFILE.profile"
CONFIG_SETTINGS="${SCRIPT_DIR}/konsolerc"


setup_config() {
    printf '[INFO] Setting up konsole profile: %s\n' "${CONFIG_PROFILES}"
    mkdir -p "${HOME}/.local/share/konsole/"
    cp -p "${CONFIG_PROFILES}" "${HOME}/.local/share/konsole/"

    printf '[INFO] Setting up konsole settings: %s\n' "${CONFIG_SETTINGS}"
    cp -p "${CONFIG_SETTINGS}" "${HOME}/.config/konsolerc"

    printf "\n"
}


main() {
    setup_config
}

main
