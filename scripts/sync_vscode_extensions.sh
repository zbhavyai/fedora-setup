#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
EXTENSIONS_FILE="${SCRIPT_DIR}/../group_vars/vscode_extensions.yaml"
PROFILES=("DEFAULT" "JAVA" "PYTHON")

create_header() {
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
    create_header
    list_installed_extensions
}

main
