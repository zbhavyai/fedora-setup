#!/bin/bash
#
# author        : bhavyai
# description   : get list of installed flatpak apps

SCRIPT_DIR="$(dirname "$0")"
OUTPUT_FILE="${SCRIPT_DIR}/install.txt"

flatpak list --app --columns=application | sort > "${OUTPUT_FILE}"
