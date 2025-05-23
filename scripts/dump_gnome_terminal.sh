#!/bin/bash
# Author        : github.com/zbhavyai
# Purpose       : Update gnome-terminal profile dump

SCRIPT_DIR="$(dirname "$0")"
CONFIG_PROFILES="${SCRIPT_DIR}/../roles/gnome-terminal/files/profiles.conf"
CONFIG_KEYBINDINGS="${SCRIPT_DIR}/../roles/gnome-terminal/files/keybindings.conf"

dump_config() {
    dconf dump /org/gnome/terminal/legacy/profiles:/ >"${CONFIG_PROFILES}"
    dconf dump /org/gnome/terminal/legacy/keybindings/ >"${CONFIG_KEYBINDINGS}"
}

main() {
    dump_config
}

main
