#!/bin/bash
# Author        : github.com/zbhavyai
# Purpose       : Load nautilus preferences from the config file


SCRIPT_DIR="$(dirname "$0")"
CONFIG_PREF="${SCRIPT_DIR}/preferences.conf"

setup_config() {
    printf '[INFO] Setting up nautilus preferences: %s\n' "${CONFIG_PREF}"
    dconf load /org/gnome/nautilus/preferences/ < "${CONFIG_PREF}"

    printf "\n"
}


main() {
    setup_config
}

main
