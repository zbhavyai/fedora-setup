#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
SRC_SETTINGS_FILE="${HOME}/.config/Antigravity/User/settings.json"
DST_SETTINGS_FILE="${SCRIPT_DIR}/../roles/antigravity/files/settings.jsonc"
SRC_KEYBINDINGS_FILE="${HOME}/.config/Antigravity/User/keybindings.json"
DST_KEYBINDINGS_FILE="${SCRIPT_DIR}/../roles/antigravity/files/keybindings.jsonc"

function sync_settings() {
    cp "${SRC_SETTINGS_FILE}" "${DST_SETTINGS_FILE}"
}

function sync_keybindings() {
    cp "${SRC_KEYBINDINGS_FILE}" "${DST_KEYBINDINGS_FILE}"
}

function main() {
    sync_settings
    sync_keybindings
}

main
