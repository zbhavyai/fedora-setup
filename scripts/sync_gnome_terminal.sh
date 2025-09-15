#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
CONFIG_PROFILES="${SCRIPT_DIR}/../roles/gnome_terminal/files/profiles.conf"
CONFIG_KEYBINDINGS="${SCRIPT_DIR}/../roles/gnome_terminal/files/keybindings.conf"

function get_config() {
    dconf dump /org/gnome/terminal/legacy/profiles:/ >"${CONFIG_PROFILES}"
    dconf dump /org/gnome/terminal/legacy/keybindings/ >"${CONFIG_KEYBINDINGS}"
}

function main() {
    get_config
}

main
