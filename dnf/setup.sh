#!/bin/bash
# Author        : github.com/zbhavyai
# Purpose       : Remove and install dnf packages


SCRIPT_DIR="$(dirname "$0")"
FILE_INSTALL="${SCRIPT_DIR}/install.txt"
FILE_REMOVE="${SCRIPT_DIR}/remove.txt"

setup_repos() {
    sudo dnf -y update
}

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
    sudo dnf install -y "${packages[@]}"
    printf "\n\n"
}

remove_packages() {
    packages=()
    while IFS= read -r line || [[ -n "$line" ]]; do
        # Skip empty lines and lines starting with #
        if [[ -z "$line" || "$line" =~ ^#.* ]]; then
            continue
        fi

        # Add packages to the array
        packages+=("$line")
    done < "${FILE_REMOVE}"

    printf '[INFO] Remove: %s\n' "${packages[*]}"
    sudo dnf remove -y "${packages[@]}"
    printf "\n\n"
}


main() {
    remove_packages
    setup_repos
    install_packages
}

main
