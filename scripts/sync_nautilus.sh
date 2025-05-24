#!/bin/bash

SCRIPT_DIR="$(dirname "$0")"
CONFIG_PREF="${SCRIPT_DIR}/../roles/nautilus/files/preferences.conf"

get_config() {
    dconf dump /org/gnome/nautilus/preferences/ >"${CONFIG_PREF}"
}

main() {
    get_config
}

main
