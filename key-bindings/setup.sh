#!/bin/bash
# Author        : github.com/zbhavyai
# Purpose       : Setup key bindings


SCRIPT_DIR="$(dirname "$0")"
KB_SCREENSHOT="${SCRIPT_DIR}/screenshot.conf"
KB_MEDIA_KEYS="${SCRIPT_DIR}/mediakeys.conf"
KB_SWITCH_WINDOWS="${SCRIPT_DIR}/switchWindows.conf"
KB_TERMINAL="${SCRIPT_DIR}/terminal.conf"

setup_config() {
    dconf load /org/gnome/shell/keybindings/ < "${KB_SCREENSHOT}"
    dconf load /org/gnome/settings-daemon/plugins/media-keys/ < "${KB_MEDIA_KEYS}"
    dconf load /org/gnome/desktop/wm/keybindings/ < "${KB_SWITCH_WINDOWS}"
    dconf load /org/gnome/terminal/legacy/keybindings/ < "${KB_TERMINAL}"

    printf "\n"
}


main() {
    setup_config
}

main
