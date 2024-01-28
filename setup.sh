#!/bin/bash
# Author        : github.com/zbhavyai
# Purpose       : Automate setup


SCRIPT_DIR="$(dirname "$0")"

setup_dnf() {
    local SCRIPT="${SCRIPT_DIR}/dnf/setup.sh"
    /bin/bash "${SCRIPT}"
}

setup_flatpak() {
    local SCRIPT="${SCRIPT_DIR}/flatpak/setup.sh"
    /bin/bash "${SCRIPT}"
}

setup_bash() {
    local SCRIPT="${SCRIPT_DIR}/bash/setup.sh"
    /bin/bash "${SCRIPT}"
}

setup_git() {
    local SCRIPT="${SCRIPT_DIR}/git/setup.sh"
    /bin/bash "${SCRIPT}"
}

setup_vim() {
    local SCRIPT="${SCRIPT_DIR}/vim/setup.sh"
    /bin/bash "${SCRIPT}"
}

setup_gnometerminal() {
    local SCRIPT="${SCRIPT_DIR}/gnome-terminal/setup.sh"
    /bin/bash "${SCRIPT}"
}

setup_ssh() {
    local SCRIPT="${SCRIPT_DIR}/ssh/setup.sh"
    /bin/bash "${SCRIPT}"
}


main() {
    setup_dnf
    setup_flatpak
    setup_bash
    setup_git
    setup_vim
    setup_gnometerminal
    setup_ssh
}

main
