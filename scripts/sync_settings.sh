#!/bin/bash

SCRIPT_DIR="$(dirname "$0")"
CONFIG_APP_FOLDERS="${SCRIPT_DIR}/../roles/settings/files/appFolders.conf"
CONFIG_APP_PICKER="${SCRIPT_DIR}/../roles/settings/files/appPicker.conf"
CONFIG_FAVORITES="${SCRIPT_DIR}/../roles/settings/files/favorites.conf"
CONFIG_MUTTER="${SCRIPT_DIR}/../roles/settings/files/mutter.conf"
CONFIG_INTERFACE="${SCRIPT_DIR}/../roles/settings/files/tweaks.conf"

get_config() {
    dconf dump /org/gnome/desktop/app-folders/ >"${CONFIG_APP_FOLDERS}"
    dconf dump /org/gnome/mutter/ >"${CONFIG_MUTTER}"
    dconf dump /org/gnome/desktop/interface/ >"${CONFIG_INTERFACE}"
    dconf read /org/gnome/shell/app-picker-layout >"${CONFIG_APP_PICKER}"
    dconf read /org/gnome/shell/favorite-apps >"${CONFIG_FAVORITES}"
}

main() {
    get_config
}

main
