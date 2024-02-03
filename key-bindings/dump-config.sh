#!/bin/bash
# Author        : github.com/zbhavyai
# Purpose       : Update key bindings configuration dumps


SCRIPT_DIR="$(dirname "$0")"
KB_SCREENSHOT="${SCRIPT_DIR}/screenshot.conf"
KB_MEDIA_KEYS="${SCRIPT_DIR}/mediakeys.conf"
KB_SWITCH_WINDOWS="${SCRIPT_DIR}/switchWindows.conf"
KB_TERMINAL="${SCRIPT_DIR}/terminal.conf"

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
