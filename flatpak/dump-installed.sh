#!/bin/bash
# Author        : github.com/zbhavyai
# Purpose       : Update installed flatpak apps dump


SCRIPT_DIR="$(dirname "$0")"
APPS_FILE="${SCRIPT_DIR}/install.txt"

dump_installed() {
    flatpak list --app --columns=application | sort > "${APPS_FILE}"
}


main() {
    dump_installed
}

main
