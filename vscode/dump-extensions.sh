#!/bin/bash
# Author        : github.com/zbhavyai
# Purpose       : Update installed VS Code extensions dump


SCRIPT_DIR="$(dirname "$0")"
EXTNS_FILE="${SCRIPT_DIR}/install.txt"

dump_extensions() {
    code --list-extensions | sort > "${EXTNS_FILE}"
}


main() {
    dump_extensions
}

main

