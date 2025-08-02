#!/bin/bash
#
# author        : github.com/zbhavyai
# description   : Toggle between Userful Grafana and vanilla Grafana (same version, 7.5.15)

CURR_SCRIPT=$(readlink -f "$0")
CURR_SCRIPT_PATH=$(dirname "${CURR_SCRIPT}")

VANILLA_RPM="grafana-7.5.15-1.x86_64.rpm"
VANILLA_URL="https://dl.grafana.com/oss/release/${VANILLA_RPM}"

# help
# -------------------------------------------------------------------------------------
function Help() {
    echo
    echo "Toggle between Userful's custom Grafana build and the official Grafana OSS release."
    echo
    echo "Usage:"
    echo "    ${0} [OPTION]"
    echo
    echo "Options:"
    echo "    -v | --replace     Replace Userful Grafana with vanilla Grafana OSS."
    echo "    -r | --restore     Restore Userful Grafana from the internal repository."
    echo "    -h | --help        Show this help message."
    echo
    echo
    echo "Examples:"
    echo "    ${0} --replace"
    echo "    ${0} --restore"
    echo
}

# prettyLog
# -------------------------------------------------------------------------------------
function prettyLog() {
    TIMESTAMP=$(date +"%F %T.%3N %z")
    LEVEL=$1
    MESSAGE=$2

    printf "%s [%5s] %s.\n" "${TIMESTAMP}" "${LEVEL}" "${MESSAGE}"
}

# Grafana service restarter
# -------------------------------------------------------------------------------------
function restartGrafana() {
    systemctl restart userful-grafana.service
}

# check if either/any Grafana is installed
# -------------------------------------------------------------------------------------
function isGrafanaInstalled() {
    rpm -q grafana &>/dev/null
}

# get the complete version of the installed Grafana
# -------------------------------------------------------------------------------------
function getInstalledGrafana() {
    rpm -q grafana 2>/dev/null
}

# check if the installed Grafana is Userful Grafana
# -------------------------------------------------------------------------------------
function isUserfulGrafana() {
    if ! isGrafanaInstalled; then
        return 1
    fi
    [[ "$(getInstalledGrafana)" == *userful* ]]
}

# replace whitelabeled Grafana installation with Grafana OSS
# -------------------------------------------------------------------------------------
replaceWithVanilla() {
    if ! isGrafanaInstalled; then
        prettyLog "INFO" "No Grafana installed. Proceeding with vanilla Grafana installation"
    elif ! isUserfulGrafana; then
        prettyLog "INFO" "Grafana OSS already installed. No action taken"
        exit 0
    else
        prettyLog "INFO" "Removing Userful Grafana"
        rpm --erase --nodeps grafana
    fi

    prettyLog "INFO" "Downloading Grafana OSS RPM"
    curl -fsSL "$VANILLA_URL" -o "/tmp/$VANILLA_RPM"

    local PROBLEMATIC_DIRECTORY="/etc/init.d"
    if [ -d "$PROBLEMATIC_DIRECTORY" ] && [ ! -L "$PROBLEMATIC_DIRECTORY" ]; then
        prettyLog "INFO" "Moving $PROBLEMATIC_DIRECTORY to ${PROBLEMATIC_DIRECTORY}.old"
        mv "$PROBLEMATIC_DIRECTORY" "${PROBLEMATIC_DIRECTORY}.old"
    fi

    dnf install --assumeyes chkconfig initscripts-service

    prettyLog "[INFO] Installing Grafana OSS"
    rpm -i "/tmp/$VANILLA_RPM"

    restartGrafana

    prettyLog "INFO" "Replaced current Grafana with Grafana OSS"
}

# restore whitelabeled Grafana installation
# -------------------------------------------------------------------------------------
restoreUserfulGrafana() {
    if isUserfulGrafana; then
        prettyLog "INFO" "Userful Grafana already installed. No action taken"
        exit 0
    fi

    if isGrafanaInstalled; then
        prettyLog "INFO" "Removing vanilla Grafana"
        rpm --erase --nodeps grafana
    else
        prettyLog "INFO" "No Grafana installed. Proceeding with Userful Grafana installation"
    fi

    prettyLog "INFO" "Installing Userful Grafana from internal repositories"
    dnf install --assumeyes grafana --allowerasing

    restartGrafana

    prettyLog "INFO" "Restored Userful Grafana"
}

# driver code
# -------------------------------------------------------------------------------------
if [ $# -ne 1 ]; then
    Help
    exit 1
fi

while [[ $# -gt 0 ]]; do
    case "$1" in
    -h | --help)
        Help
        exit
        ;;
    -v | --replace)
        replaceWithVanilla
        exit
        ;;
    -r | --restore)
        restoreUserfulGrafana
        exit
        ;;
    *)
        prettyLog "FATAL" "Invalid option \"$1\". Use --help for more information"
        exit 1
        ;;
    esac
done
