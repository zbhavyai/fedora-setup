#!/usr/bin/env bash
set -euo pipefail

SRC_VM_OPTIONS="/opt/intellij-idea/bin/idea64.vmoptions"
SRC_CONFIG_DIR="${HOME}/.config/intellij-idea/config"

SCRIPT_DIR="$(dirname "$0")"
DST_VM_OPTIONS="${SCRIPT_DIR}/../roles/intellij_idea/files/idea64.vmoptions"
DST_CONFIG_DIR="${SCRIPT_DIR}/../roles/intellij_idea/files/config"

get_settings() {
    cp "${SRC_VM_OPTIONS}" "${DST_VM_OPTIONS}"

    rm -rf "${DST_CONFIG_DIR}"
    rsync -a \
        --include 'disabled_plugins.txt' \
        --include 'keymaps/' \
        --include 'keymaps/***' \
        --include 'options/' \
        --include 'options/linux/' \
        --include 'options/linux/keymap.xml' \
        --include 'options/AIOnboardingPromoWindowAdvisor.xml' \
        --include 'options/baseRefactoring.xml' \
        --include 'options/colors.scheme.xml' \
        --include 'options/console-font.xml' \
        --include 'options/editor-font.xml' \
        --include 'options/editor.xml' \
        --include 'options/github-copilot.xml' \
        --include 'options/ide.general.xml' \
        --include 'options/inline.factors.completion.xml' \
        --include 'options/keymapFlags.xml' \
        --include 'options/parameter.hints.xml' \
        --include 'options/project.default.xml' \
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

main() {
    get_settings
}

main
