#!/bin/bash
# Author        : github.com/zbhavyai
# Purpose       : Install favourite flatpak apps


SCRIPT_DIR="$(dirname "$0")"
FILE_INSTALL="${SCRIPT_DIR}/install.txt"

install_packages() {
    packages=()
    while IFS= read -r line || [[ -n "$line" ]]; do
        # Skip empty lines and lines starting with #
        if [[ -z "$line" || "$line" =~ ^#.* ]]; then
            continue
        fi

        # Add packages to the array
        packages+=("$line")
    done < "${FILE_INSTALL}"

    printf '[INFO] Install: %s\n' "${packages[*]}"
    flatpak install -y flathub "${packages[@]}"
    printf "\n\n"
}


main() {
    install_packages
}

main
