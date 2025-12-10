#!/usr/bin/env bash
set -euo pipefail

SRC_VM_OPTIONS="/opt/pycharm/bin/pycharm64.vmoptions"
SRC_CONFIG_DIR="${HOME}/.config/jetbrains/pycharm/config"

SCRIPT_DIR="$(dirname "$0")"
DST_VM_OPTIONS="${SCRIPT_DIR}/../roles/pycharm/files/pycharm64.vmoptions"
DST_CONFIG_DIR="${SCRIPT_DIR}/../roles/pycharm/files/config"

function get_settings() {
    cp "${SRC_VM_OPTIONS}" "${DST_VM_OPTIONS}"

    rm -rf "${DST_CONFIG_DIR}"
    rsync -a \
        --include 'disabled_plugins.txt' \
        --include 'keymaps/' \
        --include 'keymaps/***' \
        --include 'options/' \
        --include 'options/linux/' \
        --include 'options/linux/keymap.xml' \
        --include 'options/baseRefactoring.xml' \
        --include 'options/colors.scheme.xml' \
        --include 'options/console-font.xml' \
        --include 'options/editor-font.xml' \
        --include 'options/editor.xml' \
        --include 'options/filetypes.xml' \
        --include 'options/github-copilot.xml' \
        --include 'options/keymapFlags.xml' \
        --include 'options/parameter.hints.xml' \
        --include 'options/projectView.xml' \
        --include 'options/terminal-font.xml' \
        --include 'options/terminal.xml' \
        --include 'options/ui.lnf.xml' \
        --include 'options/updates.xml' \
        --exclude '*.db' \
        --exclude '*.zip' \
        --exclude '*.jar' \
        --exclude '*' \
        "${SRC_CONFIG_DIR}/" "${DST_CONFIG_DIR}/"
}

function main() {
    get_settings
}

main
