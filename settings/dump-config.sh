#!/bin/bash
# Author        : github.com/zbhavyai
# Purpose       : Update settings like app picker layout preferences dump


SCRIPT_DIR="$(dirname "$0")"
CONFIG_APP_FOLDERS="${SCRIPT_DIR}/appFolders.conf"
CONFIG_MUTTER="${SCRIPT_DIR}/mutter.conf"
CONFIG_INTERFACE="${SCRIPT_DIR}/tweaks.conf"

dump_config() {
    dconf dump /org/gnome/desktop/app-folders/ > "${CONFIG_APP_FOLDERS}"
    dconf dump /org/gnome/mutter/ > "${CONFIG_MUTTER}"
    dconf dump /org/gnome/desktop/interface/ > "${CONFIG_INTERFACE}"
    # dconf dump /org/gnome/shell/ > "${CONFIG_SHELL}"
}


main() {
    dump_config
}

main
