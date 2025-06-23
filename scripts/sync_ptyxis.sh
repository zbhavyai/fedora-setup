#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
CONFIG_PREF="${SCRIPT_DIR}/../roles/ptyxis/files/preferences.conf"

get_config() {
    dconf dump /org/gnome/Ptyxis/ >"${CONFIG_PREF}"
}

main() {
    get_config
}

main
