#!/bin/bash
# Author        : github.com/zbhavyai
# Purpose       : Install VS Code extensions


SCRIPT_DIR="$(dirname "$0")"
FILE_INSTALL="${SCRIPT_DIR}/install.txt"

install_extensions() {
    while IFS= read -r line || [[ -n "$line" ]]; do
        # Skip empty lines and lines starting with #
        if [[ -z "$line" || "$line" =~ ^#.* ]]; then
            continue
        fi

        # Install extensions one by one
        printf '[INFO] Install: %s\n' "${line}"
        code --install-extension "${line}" 1> /dev/null
    done < "${FILE_INSTALL}"

    printf "\n"
}


main() {
    install_extensions
}

main
