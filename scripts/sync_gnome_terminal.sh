#!/bin/bash

SCRIPT_DIR="$(dirname "$0")"
CONFIG_PROFILES="${SCRIPT_DIR}/../roles/gnome_terminal/files/profiles.conf"
CONFIG_KEYBINDINGS="${SCRIPT_DIR}/../roles/gnome_terminal/files/keybindings.conf"

get_config() {
    dconf dump /org/gnome/terminal/legacy/profiles:/ >"${CONFIG_PROFILES}"
    dconf dump /org/gnome/terminal/legacy/keybindings/ >"${CONFIG_KEYBINDINGS}"
}

main() {
    get_config
}

main
