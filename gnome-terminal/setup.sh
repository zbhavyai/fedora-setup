#!/bin/bash
# Author        : github.com/zbhavyai
# Purpose       : Load gnome-terminal configuration from the config files


SCRIPT_DIR="$(dirname "$0")"
CONFIG_PROFILES="${SCRIPT_DIR}/profiles.conf"

setup_config() {
    printf '[INFO] Setting up gnome-terminal profiles: %s\n' "${CONFIG_PROFILES}"
    dconf load /org/gnome/terminal/legacy/profiles:/ < "${CONFIG_PROFILES}"

    printf "\n"
}


main() {
    setup_config
}

main
