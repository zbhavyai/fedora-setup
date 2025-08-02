#!/bin/bash
#
# author        : github.com/zbhavyai
# description   : Executes packet counter binaries

CURR_SCRIPT=$(readlink -f "$0")
CURR_SCRIPT_PATH=$(dirname "${CURR_SCRIPT}")

# location of packet filter binaries
BINARY_INGRESS="/usr/share/userful-packet-counter/RTSP_monitor_in"
BINARY_EGRESS="/usr/share/userful-packet-counter/RTSP_monitor_out"

# log files
LOG_INGRESS="/var/log/userful/RTSP_monitor_in.log"
LOG_EGRESS="/var/log/userful/RTSP_monitor_out.log"

# help function
# -------------------------------------------------------------------------------------
function Help() {
    echo
    echo "Executes packet counter binaries for ingress and egress traffic."
    echo
    echo "Usage:"
    echo "    ${0} [OPTION]"
    echo
    echo "Options:"
    echo "    -e  execute the packet counter binaries"
    echo "    -h  show this help message"
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

# execute the binaries
# -------------------------------------------------------------------------------------
function executePacketCounterBinaries() {
    # check if the binaries exist
    if [[ ! -x "${BINARY_INGRESS}" || ! -x "${BINARY_EGRESS}" ]]; then
        prettyLog "FATAL" "Binary files not found or not executable"
        return 1
    fi

    # start the ingress and egress binaries
    "${BINARY_INGRESS}" &>${LOG_INGRESS} &
    INGRESS_PID=$!

    "${BINARY_EGRESS}" &>${LOG_EGRESS} &
    EGRESS_PID=$!

    cleanup() {
        prettyLog "INFO" "Caught signal, cleaning up"
        pkill -2 -f "RTSP_monitor"
        prettyLog "INFO" "Execution terminated"
    }

    # trap ctrl+c and termination signals
    trap cleanup SIGINT SIGTERM

    prettyLog "INFO" "Started ${BINARY_INGRESS} with PID=${INGRESS_PID}"
    prettyLog "INFO" "Logging at ${LOG_INGRESS}"
    echo
    prettyLog "INFO" "Started ${BINARY_EGRESS} with PID=${EGRESS_PID}"
    prettyLog "INFO" "Logging at ${LOG_EGRESS}"

    wait
}

# driver code
# -------------------------------------------------------------------------------------
while getopts ":he" opt; do
    case "$opt" in
    h)
        Help
        exit
        ;;
    e)
        executePacketCounterBinaries
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
