#!/bin/bash
# Author        : github.com/zbhavyai
# Purpose       : Setup pgadmin


SCRIPT_DIR="$(dirname "$0")"

setup_repos() {
    # source: https://www.pgadmin.org/download/pgadmin-4-rpm/
    sudo rpm --install https://ftp.postgresql.org/pub/pgadmin/pgadmin4/yum/pgadmin4-fedora-repo-2-1.noarch.rpm
}

install_packages() {
    sudo dnf install -y pgadmin4-desktop
    printf "\n\n"
}


main() {
    setup_repos
    install_packages
}

main
