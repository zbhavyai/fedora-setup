#!/bin/bash
# Author        : github.com/zbhavyai
# Purpose       : Install VS Code extensions


SCRIPT_DIR="$(dirname "$0")"
EXTS_INSTALL="${SCRIPT_DIR}/install.txt"

setup_repos() {
    # source: https://code.visualstudio.com/docs/setup/linux#_rhel-fedora-and-centos-based-distributions
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
}

install_packages() {
    sudo dnf install -y code
}

install_extensions() {
    while IFS= read -r line || [[ -n "$line" ]]; do
        # Skip empty lines and lines starting with #
        if [[ -z "$line" || "$line" =~ ^#.* ]]; then
            continue
        fi

        # Install extensions one by one
        printf '[INFO] Install: %s\n' "${line}"
        code --install-extension "${line}" 1> /dev/null
    done < "${EXTS_INSTALL}"

    printf "\n"
}


main() {
    setup_repos
    install_packages
    install_extensions
}

main
