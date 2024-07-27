#!/bin/bash
# Author        : github.com/zbhavyai
# Purpose       : Miscellaneous settings


SCRIPT_DIR="$(dirname "$0")"
CONF_LOGIND="/etc/systemd/logind.conf"
CONFIG_APP_FOLDERS="${SCRIPT_DIR}/appFolders.conf"
CONFIG_MUTTER="${SCRIPT_DIR}/mutter.conf"
CONFIG_INTERFACE="${SCRIPT_DIR}/tweaks.conf"

setup_lidignore() {
    local PROPERTY="$1"

    if grep -q "^#*${PROPERTY}" "${CONF_LOGIND}"; then
        # remove any leading #
        sudo sed -i 's/^#*\('${PROPERTY}'\)/\1/' "${CONF_LOGIND}"

    elif ! grep -q "^${PROPERTY}" "${CONF_LOGIND}"; then
        # add property
        echo "${PROPERTY}" | sudo tee -a "${CONF_LOGIND}" > /dev/null
    fi
}

setup_config() {
    printf '[INFO] Setting up app folders: %s\n' "${CONFIG_APP_FOLDERS}"
    dconf load /org/gnome/desktop/app-folders/ < "${CONFIG_APP_FOLDERS}"

    printf '[INFO] Setting up mutter: %s\n' "${CONFIG_MUTTER}"
    dconf load /org/gnome/mutter/ < "${CONFIG_MUTTER}"

    printf '[INFO] Setting up interface settings: %s\n' "${CONFIG_INTERFACE}"
    dconf load /org/gnome/desktop/interface/ < "${CONFIG_INTERFACE}"

    printf "\n"
}


main() {
    setup_lidignore "HandleLidSwitch=ignore"
    setup_lidignore "LidSwitchIgnoreInhibited=yes"
    setup_config
}

main
