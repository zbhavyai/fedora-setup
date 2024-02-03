#!/bin/bash
# Author        : github.com/zbhavyai
# Purpose       : Update gnome-terminal profile dump


SCRIPT_DIR="$(dirname "$0")"
CONFIG_PROFILES="${SCRIPT_DIR}/profiles.conf"

dump_config() {
    dconf dump /org/gnome/terminal/legacy/profiles:/ > "${CONFIG_PROFILES}"
}


main() {
    dump_config
}

main
