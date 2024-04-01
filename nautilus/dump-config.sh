#!/bin/bash
# Author        : github.com/zbhavyai
# Purpose       : Update nautilus preferences dump


SCRIPT_DIR="$(dirname "$0")"
CONFIG_PREF="${SCRIPT_DIR}/preferences.conf"

dump_config() {
    dconf dump /org/gnome/nautilus/preferences/ > "${CONFIG_PREF}"
}


main() {
    dump_config
}

main
