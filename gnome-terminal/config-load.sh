#!/bin/bash
#
# author        : bhavyai
# description   : load gnome-terminal configuration from the dump

SCRIPT_DIR="$(dirname "$0")"
DUMP_KEYBINDINGS="${SCRIPT_DIR}/keybindings.conf"
DUMP_PROFILES="${SCRIPT_DIR}/profiles.conf"

dconf load /org/gnome/terminal/legacy/keybindings/ < "${DUMP_KEYBINDINGS}"
dconf load /org/gnome/terminal/legacy/profiles:/ < "${DUMP_PROFILES}"
