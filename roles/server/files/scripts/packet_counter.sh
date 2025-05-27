#!/bin/bash
#
# author        : bhavyai
# description   : executes and kills packet counter binaries
# how to run    : ./packet_counter.sh -s | -u

# Binaries
INGRESS_BINARY="/usr/share/userful-packet-counter/RTSP_monitor_in"
EGRESS_BINARY="/usr/share/userful-packet-counter/RTSP_monitor_out"

# Log files
INGRESS_LOG_FILE="/var/log/userful/RTSP_monitor_in.log"
EGRESS_LOG_FILE="/var/log/userful/RTSP_monitor_out.log"

# help function
# -------------------------------------------------------------------------------------
function Help() {
    echo
    echo "Usage: ${0} [-h] [-s] [-k]"
    echo
    echo "Options:"
    echo "  -h  Show this help message and exit."
    echo "  -s  Start the services."
    echo "  -k  Kill the services."
    echo
}

# Start the services
# -------------------------------------------------------------------------------------
function start_services() {
    # Check if the binaries exist
    if [[ ! -x "${INGRESS_BINARY}" || ! -x "${EGRESS_BINARY}" ]]; then
        echo "[FATAL] Binary files not found or not executable."
        exit 1
    fi

    # kill if running before
    stop_services
    echo

    # Start the services in the background and store their PIDs in files
    "${INGRESS_BINARY}" &>${INGRESS_LOG_FILE} &
    INGRESS_PID=$!

    "${EGRESS_BINARY}" &>${EGRESS_LOG_FILE} &
    EGRESS_PID=$!

    echo "[ INFO] PID="${INGRESS_PID}". Started ${INGRESS_BINARY}"
    echo "[ INFO] PID="${EGRESS_PID}". Started ${EGRESS_BINARY}"

    echo "[ INFO] Logging at ${INGRESS_LOG_FILE}"
    echo "[ INFO] Logging at ${EGRESS_LOG_FILE}"
}

# Stop the services
# -------------------------------------------------------------------------------------
function stop_services() {
    pkill -2 -f "RTSP_monitor"
    echo "[ INFO] Services stopped"
}

# driver code
# -------------------------------------------------------------------------------------
start=false
stop=false

# Parse command-line options
while getopts "hsk" opt; do
    case "$opt" in
    h) # display usage
        Help
        exit
        ;;
    s) # Start services
        start=true
        ;;
    k) # Stop services
        stop=true
        ;;
    \?) # Invalid option
        Help
        exit
        ;;
    esac
done

# Check if both start and stop options are given
if [[ "$start" = true && "$stop" = true ]]; then
    echo "[FATAL] Cannot specify both start and kill options"
    echo
    Help
fi

# Check if any option is specified
if [[ "$start" = false && "$stop" = false ]]; then
    echo "[FATAL] No option specified"
    echo
    Help
fi

if [[ "$start" = true ]]; then
    start_services
elif [[ "$stop" = true ]]; then
    stop_services
fi
