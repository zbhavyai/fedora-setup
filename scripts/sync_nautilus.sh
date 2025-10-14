#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
CONFIG_PREF="${SCRIPT_DIR}/../roles/nautilus/files/preferences.conf"
CONFIG_FILECHOOSER="${SCRIPT_DIR}/../roles/nautilus/files/filechooser.conf"

function get_config() {
    dconf dump /org/gnome/nautilus/preferences/ >"${CONFIG_PREF}"
    dconf dump /org/gtk/gtk4/settings/file-chooser/ >"${CONFIG_FILECHOOSER}"
}

function main() {
    get_config
}

main
