#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
CONFIG_APP_FOLDERS="${SCRIPT_DIR}/../roles/settings/files/appFolders.conf"
CONFIG_APP_PICKER="${SCRIPT_DIR}/../roles/settings/files/appPicker.conf"
CONFIG_FAVORITES="${SCRIPT_DIR}/../roles/settings/files/favorites.conf"
CONFIG_MUTTER="${SCRIPT_DIR}/../roles/settings/files/mutter.conf"
CONFIG_INTERFACE="${SCRIPT_DIR}/../roles/settings/files/desktop_interface.conf"
CONFIG_TOUCHPAD="${SCRIPT_DIR}/../roles/settings/files/touchpad.conf"
CONFIG_SCREEN_TIME="${SCRIPT_DIR}/../roles/settings/files/wellbeing_screen_time.conf"
CONFIG_BREAK_REMINDERS="${SCRIPT_DIR}/../roles/settings/files/wellbeing_break_reminders.conf"
CONFIG_NIGHT_LIGHT="${SCRIPT_DIR}/../roles/settings/files/night_light.conf"
CONFIG_WM="${SCRIPT_DIR}/../roles/settings/files/wm.conf"
CONFIG_SEARCH_PROVIDERS="${SCRIPT_DIR}/../roles/settings/files/search_providers.conf"
CONFIG_POWER_SAVING="${SCRIPT_DIR}/../roles/settings/files/power_saving.conf"
CONFIG_SCREEN_BLANK="${SCRIPT_DIR}/../roles/settings/files/screen_blank.conf"

function get_config() {
    dconf dump /org/gnome/desktop/app-folders/ >"${CONFIG_APP_FOLDERS}"
    dconf dump /org/gnome/mutter/ >"${CONFIG_MUTTER}"
    dconf dump /org/gnome/desktop/interface/ >"${CONFIG_INTERFACE}"
    dconf read /org/gnome/shell/app-picker-layout >"${CONFIG_APP_PICKER}"
    dconf read /org/gnome/shell/favorite-apps >"${CONFIG_FAVORITES}"
    dconf dump /org/gnome/desktop/peripherals/touchpad/ >"${CONFIG_TOUCHPAD}"
    dconf dump /org/gnome/desktop/screen-time-limits/ >"${CONFIG_SCREEN_TIME}"
    dconf dump /org/gnome/desktop/break-reminders/ >"${CONFIG_BREAK_REMINDERS}"
    dconf dump /org/gnome/settings-daemon/plugins/color/ | grep -v "night-light-last-coordinates" >"${CONFIG_NIGHT_LIGHT}"
    dconf dump /org/gnome/desktop/wm/preferences/ >"${CONFIG_WM}"
    dconf dump /org/gnome/desktop/search-providers/ >"${CONFIG_SEARCH_PROVIDERS}"
    dconf dump /org/gnome/settings-daemon/plugins/power/ >"${CONFIG_POWER_SAVING}"
    dconf dump /org/gnome/desktop/session/ >"${CONFIG_SCREEN_BLANK}"
}

function main() {
    get_config
}

main
