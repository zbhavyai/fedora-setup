#!/bin/bash
# Author        : github.com/zbhavyai
# Purpose       : Load gnome-text-editor preferences from the config file


SCRIPT_DIR="$(dirname "$0")"
CONFIG_PREF="${SCRIPT_DIR}/preferences.conf"

setup_config() {
    printf '[INFO] Setting up gnome-text-editor preferences: %s\n' "${CONFIG_PREF}"
    dconf load /org/gnome/TextEditor/ < "${CONFIG_PREF}"

    printf "\n"
}


main() {
    setup_config
}

main
