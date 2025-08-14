#!/bin/bash
#
# author        : github.com/zbhavyai
# description   : Test colors in the terminal

CURR_SCRIPT=$(readlink -f "$0")
CURR_SCRIPT_PATH=$(dirname "${CURR_SCRIPT}")

# help function
# -------------------------------------------------------------------------------------
function Help() {
    echo
    echo "Test colors in the terminal"
    echo
    echo "Usage:"
    echo "    ${0} [OPTION]"
    echo
    echo "Options:"
    echo "    -h    show this help message"
    echo "    -s    print SGR code grid"
    echo "    -f    print indexed 256 foreground grid"
    echo "    -b    print indexed 256 background grid"
    echo "    -t    print tput palette"
    echo
    echo
    echo "Examples:"
    echo "-> Print SGR code grid"
    echo "    ${0} -s"
    echo
    echo "-> Print indexed 256 foreground grid"
    echo "    ${0} -f"
    echo
    echo "-> Print indexed 256 background grid"
    echo "    ${0} -b"
    echo
    echo "-> Print tput palette"
    echo "    ${0} -t"
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

# sgr code grid
# -------------------------------------------------------------------------------------
function sgr_code_grid() {
    local -i count=8
    local RESET="\033[0m"

    for N in {0..255}; do
        local SGR="\033[${N}m"
        printf "%b%16s%b" "$SGR" "$SGR" "$RESET"

        if ((--count == 0)); then
            printf "\n"
            count=8
        else
            printf "\t"
        fi
    done
}

# indexed 256 foreground grid
# -------------------------------------------------------------------------------------
function indexed256_fg_grid() {
    local -i count=8
    local RESET="\033[0m"

    for N in {0..255}; do
        local FG="\033[38;5;${N}m"
        printf "%b%16s%b" "$FG" "$FG" "$RESET"

        if ((--count == 0)); then
            printf "\n"
            count=8
        else
            printf "\t"
        fi
    done
}

# indexed 256 background grid
# -------------------------------------------------------------------------------------
function indexed256_bg_grid() {
    local -i count=8
    local RESET="\033[0m"

    for N in {0..255}; do
        local BG="\033[48;5;${N}m"
        printf "%b%16s%b" "$BG" "$BG" "$RESET"

        if ((--count == 0)); then
            printf "\n"
            count=8
        else
            printf "\t"
        fi
    done
}

# tput colors
# -------------------------------------------------------------------------------------
function print_tput_palette() {
    # pass a term as an argument, like xterm-mono, xterm, xterm-256color
    local term="${1:-$TERM}"

    # sanity checks
    if ! command -v tput >/dev/null 2>&1; then
        prettyLog "ERROR" "tput not found in PATH"
        return 1
    fi

    local supportedColors
    supportedColors=$(tput -T "$term" colors 2>/dev/null || echo -1)

    prettyLog "INFO" "Current shell TERM=$TERM"
    prettyLog "INFO" "Target term $term"
    prettyLog "INFO" "Colors supported by $term = $supportedColors"

    if ! [[ "$supportedColors" =~ ^[0-9]+$ ]] || ((supportedColors <= 0)); then
        prettyLog "WARN" "This term reports no color support. Nothing to show."
        return 0
    fi

    prettyLog "INFO" "Foreground: tput -T %s setaf <n>" "$term"
    prettyLog "INFO" "Background: tput -T %s setab <n>" "$term"

    local -i count=8
    local reset fg bg

    reset=$(tput -T "$term" sgr0 2>/dev/null || printf '\033[0m')

    for ((n = 0; n < supportedColors; n++)); do
        fg=$(tput -T "$term" setaf "$n" 2>/dev/null || printf '')
        bg=$(tput -T "$term" setab "$n" 2>/dev/null || printf '')

        printf "%bFG %3d%b  " "$fg" "$n" "$reset"
        printf "%bBG %3d%b  " "$bg" "$n" "$reset"

        if ((--count == 0)); then
            printf "\n"
            count=8
        else
            printf "\t"
        fi
    done
}

# driver code
# -------------------------------------------------------------------------------------
while getopts ":hsfbt" opt; do
    case "$opt" in
    h)
        Help
        exit
        ;;
    s)
        sgr_code_grid
        ;;
    f)
        indexed256_fg_grid
        ;;
    b)
        indexed256_bg_grid
        ;;
    t)
        print_tput_palette
        ;;
    \?)
        prettyLog "ERROR" "Invalid option"
        Help
        exit
        ;;
    esac
done

if ((OPTIND == 1)); then
    Help
    exit
fi
