#!/bin/bash
# Author        : github.com/zbhavyai
# Purpose       : Update gnome-text-editor preferences dump

SCRIPT_DIR="$(dirname "$0")"
CONFIG_PREF="${SCRIPT_DIR}/../roles/gnome-text-editor/files/preferences.conf"

dump_config() {
    dconf dump /org/gnome/TextEditor/ >"${CONFIG_PREF}"
}

main() {
    dump_config
}

main
