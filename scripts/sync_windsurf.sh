#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
SRC_KEYBINDINGS_FILE="${HOME}/.config/Windsurf/User/keybindings.json"
DST_KEYBINDINGS_FILE="${SCRIPT_DIR}/../roles/windsurf/files/keybindings.jsonc"

function sync_keybindings() {
    cp "${SRC_KEYBINDINGS_FILE}" "${DST_KEYBINDINGS_FILE}"
}

function main() {
    sync_keybindings
}

main
