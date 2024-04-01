#!/bin/bash
# Author        : github.com/zbhavyai
# Purpose       : Automate setup


SCRIPT_DIR="$(dirname "$0")"

setup_modules() {
    MOD=$1
    echo "[INFO] Setting up ${MOD}"

    if [ -f "${SCRIPT_DIR}/${MOD}/setup.sh" ]; then
        /bin/bash "${SCRIPT_DIR}/${MOD}/setup.sh"
    else
        echo "[EROR] No setup script found for ${MOD}"
    fi
}

main() {
    setup_modules "dnf"
    setup_modules "fonts"
    setup_modules "google-chrome"
    setup_modules "flatpak"
    setup_modules "key-bindings"
    setup_modules "bash"
    setup_modules "git"
    setup_modules "vim"
    setup_modules "ssh"
    setup_modules "vscode"
    setup_modules "settings"
    setup_modules "gnome-text-editor"
    setup_modules "nautilus"
    setup_modules "gnome-terminal"
}

main
