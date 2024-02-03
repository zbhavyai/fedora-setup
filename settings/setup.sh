#!/bin/bash
# Author        : github.com/zbhavyai
# Purpose       : Miscellaneous settings


SCRIPT_DIR="$(dirname "$0")"
CONF_LOGIND="/etc/systemd/logind.conf"

setup_lidignore() {
    local PROPERTY="HandleLidSwitch=ignore"

    if grep -q "^#*${PROPERTY}" "${CONF_LOGIND}"; then
        # remove any leading #
        sudo sed -i 's/^#*\('${PROPERTY}'\)/\1/' "${CONF_LOGIND}"

    elif ! grep -q "^${PROPERTY}" "${CONF_LOGIND}"; then
        # add property
        echo "${PROPERTY}" | sudo tee -a "${CONF_LOGIND}" > /dev/null
    fi
}


main() {
    setup_lidignore
}

main
