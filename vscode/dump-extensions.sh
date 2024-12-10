#!/bin/bash
# Author        : github.com/zbhavyai
# Purpose       : Update installed VS Code extensions dump


SCRIPT_DIR="$(dirname "$0")"
EXTNS_FILE="${SCRIPT_DIR}/install.txt"

dump_extensions() {
    echo -e "[DEFAULT]" > "${EXTNS_FILE}"
    code --list-extensions | sort >> "${EXTNS_FILE}"

    echo -e "\n[JAVA]" >> "${EXTNS_FILE}"
    code --list-extensions --profile "JAVA" | sort >> "${EXTNS_FILE}"

    echo -e "\n[PYTHON]" >> "${EXTNS_FILE}"
    code --list-extensions --profile "PYTHON" | sort >> "${EXTNS_FILE}"
}


main() {
    dump_extensions
}

main

