#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
SRC_SETTINGS_FILE="${HOME}/.config/Code/User/settings.json"
DST_SETTINGS_FILE="${SCRIPT_DIR}/../roles/vscode/files/settings.jsonc"
SRC_KEYBINDINGS_FILE="${HOME}/.config/Code/User/keybindings.json"
DST_KEYBINDINGS_FILE="${SCRIPT_DIR}/../roles/vscode/files/keybindings.jsonc"
EXTENSIONS_FILE="${SCRIPT_DIR}/../group_vars/vscode_extensions.yaml"
PROFILES=("DEFAULT" "JAVA" "PYTHON")

sync_settings() {
    cp "${SRC_SETTINGS_FILE}" "${DST_SETTINGS_FILE}"
}

sync_keybindings() {
    cp "${SRC_KEYBINDINGS_FILE}" "${DST_KEYBINDINGS_FILE}"
}

create_extension_yaml_header() {
    echo "---" >"${EXTENSIONS_FILE}"
    echo "vscode_extensions:" >>"${EXTENSIONS_FILE}"
}

list_installed_extensions() {
    for PROFILE in "${PROFILES[@]}"; do
        if [[ "$PROFILE" == "DEFAULT" ]]; then
            EXTNS=$(code --list-extensions || true)
        else
            EXTNS=$(code --list-extensions --profile "${PROFILE}" 2>/dev/null || true)
        fi

        echo "  $PROFILE:" >>"${EXTENSIONS_FILE}"
        if [[ -n "${EXTNS}" ]]; then
            while IFS= read -r EXT; do
                echo "    - $EXT" >>"${EXTENSIONS_FILE}"
            done <<<"${EXTNS}"
        fi
    done
}

main() {
    sync_settings
    sync_keybindings
    create_extension_yaml_header
    list_installed_extensions
}

main
