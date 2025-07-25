#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
KB_SCREENSHOT="${SCRIPT_DIR}/../roles/keybindings/files/screenshot.conf"
KB_MEDIA_KEYS="${SCRIPT_DIR}/../roles/keybindings/files/mediakeys.conf"
KB_SWITCH_WINDOWS="${SCRIPT_DIR}/../roles/keybindings/files/switchWindows.conf"

get_system_keybindings() {
    dconf dump /org/gnome/shell/keybindings/ >"${KB_SCREENSHOT}"
    dconf dump /org/gnome/settings-daemon/plugins/media-keys/ >"${KB_MEDIA_KEYS}"
    dconf dump /org/gnome/desktop/wm/keybindings/ >"${KB_SWITCH_WINDOWS}"
}

main() {
    get_system_keybindings
}

main
