#!/bin/bash
#
# author        : bhavyai
# description   : dump gnome-terminal configuration

SCRIPT_DIR="$(dirname "$0")"
DUMP_KEYBINDINGS="${SCRIPT_DIR}/keybindings.conf"
DUMP_PROFILES="${SCRIPT_DIR}/profiles.conf"

dconf dump /org/gnome/terminal/legacy/keybindings/ > "${DUMP_KEYBINDINGS}"
dconf dump /org/gnome/terminal/legacy/profiles:/ > "${DUMP_PROFILES}"
