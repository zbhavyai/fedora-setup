#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
CONFIG_PREF="${SCRIPT_DIR}/../roles/gnome_text_editor/files/preferences.conf"

function get_config() {
    dconf dump /org/gnome/TextEditor/ >"${CONFIG_PREF}"
    sed -i '/last-save-directory/d' "${CONFIG_PREF}"
}

function main() {
    get_config
}

main
