#!/usr/bin/env bash
# author        : github.com/zbhavyai
# description   : install dotfiles to home directory for GitHub Codespaces environment

set -euo pipefail

CURR_SCRIPT=$(readlink -f "$0")
CURR_SCRIPT_PATH=$(dirname "${CURR_SCRIPT}")

DOTFILES_SOURCE="${CURR_SCRIPT_PATH}/roles/dotfiles/files"
TARGET_DIR="${HOME}"

# logger
# -------------------------------------------------------------------------------------
function logger() {
    TIMESTAMP=$(date +"%F %T.%3N %z")
    LEVEL=$1
    MESSAGE=$2

    printf "%s [%5s] %s.\n" "${TIMESTAMP}" "${LEVEL}" "${MESSAGE}"
}

# install dotfiles
# -------------------------------------------------------------------------------------
function install_dotfiles() {
    logger "INFO" "Installing dotfiles..."

    # check if source directory exists
    if [ ! -d "${DOTFILES_SOURCE}" ]; then
        logger "ERROR" "Source directory not found at ${DOTFILES_SOURCE}"
        logger "ERROR" "Expected structure: <repo-root>/roles/dotfiles/files/"
        exit 1
    fi

    # copy all files and directories from the source to home
    if command -v rsync &>/dev/null; then
        rsync -av \
            --no-perms \
            --no-owner \
            --no-group \
            --exclude='.git' \
            "${DOTFILES_SOURCE}/" "${TARGET_DIR}/"
    else
        logger "ERROR" "rsync is not installed"
        exit 1
    fi

    logger "INFO" "Dotfiles installed successfully!"
    logger "INFO" "Files installed from: ${DOTFILES_SOURCE}"
}

# main
# -------------------------------------------------------------------------------------
function main() {
    install_dotfiles
}

main
