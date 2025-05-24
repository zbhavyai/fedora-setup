#!/bin/bash

SCRIPT_DIR="$(dirname "$0")"
CONFIG_PREF="${SCRIPT_DIR}/../roles/gnome_text_editor/files/preferences.conf"

get_config() {
    dconf dump /org/gnome/TextEditor/ >"${CONFIG_PREF}"
}

main() {
    get_config
}

main
