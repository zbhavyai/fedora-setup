#!/bin/bash
# Author        : github.com/zbhavyai
# Purpose       : Install Virtual Box


SCRIPT_DIR="$(dirname "$0")"
EXTS_INSTALL="${SCRIPT_DIR}/install.txt"
FILE_PREF="${HOME}/.config/Code/User/settings.json"
FILE_KB="${HOME}/.config/Code/User/keybindings.json"

setup_repos() {
    wget --quiet --output-document=/tmp/oracle_vbox_2016.asc https://www.virtualbox.org/download/oracle_vbox_2016.asc
    sudo rpm --import /tmp/oracle_vbox_2016.asc
    sudo dnf config-manager --add-repo https://download.virtualbox.org/virtualbox/rpm/fedora/virtualbox.repo
}

install_packages() {
    sudo dnf update
    sudo dnf install VirtualBox-7.0 virtualbox-guest-additions
}


main() {
    setup_repos
    install_packages
}

main
