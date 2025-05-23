#!/bin/bash
# Author        : github.com/zbhavyai
# Purpose       : Update key bindings configuration dumps


SCRIPT_DIR="$(dirname "$0")"
KB_SCREENSHOT="${SCRIPT_DIR}/../roles/keybindings/files/screenshot.conf"
KB_MEDIA_KEYS="${SCRIPT_DIR}/../roles/keybindings/files/mediakeys.conf"
KB_SWITCH_WINDOWS="${SCRIPT_DIR}/../roles/keybindings/files/switchWindows.conf"
KB_TERMINAL="${SCRIPT_DIR}/../roles/keybindings/files/terminal.conf"

dump_config() {
    dconf dump /org/gnome/shell/keybindings/ > "${KB_SCREENSHOT}"
    dconf dump /org/gnome/settings-daemon/plugins/media-keys/ > "${KB_MEDIA_KEYS}"
    dconf dump /org/gnome/desktop/wm/keybindings/ > "${KB_SWITCH_WINDOWS}"
    dconf dump /org/gnome/terminal/legacy/keybindings/ > "${KB_TERMINAL}"
}


main() {
    dump_config
}

main
