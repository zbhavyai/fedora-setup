#!/bin/bash
# Author        : github.com/zbhavyai

SCRIPT_DIR="$(dirname "$0")"
EXTNS_YAML="${SCRIPT_DIR}/../group_vars/laptop/vscode_extensions.yaml"

echo "vscode_extensions:" >"$EXTNS_YAML"

dump_extensions() {
    for PROFILE in DEFAULT JAVA PYTHON; do
        if [[ "$PROFILE" == "DEFAULT" ]]; then
            EXTNS=$(code --list-extensions)
        else
            EXTNS=$(code --list-extensions --profile "$PROFILE")
        fi

        echo "  $PROFILE:" >>"$EXTNS_YAML"
        for EXT in $EXTNS; do
            echo "    - $EXT" >>"$EXTNS_YAML"
        done
    done
}

main() {
    dump_extensions
}

main
