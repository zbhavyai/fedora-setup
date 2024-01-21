#!/bin/bash
#
# author        : bhavyai
# description   : get list of installed VS Code extensions

SCRIPT_DIR="$(dirname "$0")"
OUTPUT_FILE="${SCRIPT_DIR}/install.txt"

code --list-extensions | sort > "${OUTPUT_FILE}"
