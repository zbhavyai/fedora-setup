#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
CONFIG_PREF="${SCRIPT_DIR}/../roles/nautilus/files/preferences.conf"

function get_config() {
    dconf dump /org/gnome/nautilus/preferences/ >"${CONFIG_PREF}"
}

function main() {
    get_config
}

main
