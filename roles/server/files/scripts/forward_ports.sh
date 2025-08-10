#!/bin/bash
#
# author        : github.com/zbhavyai
# description   : Forward ports in firewall for direct access to various services

# ports that need to be forwarded from firewall
# -------------------------------------------------------------------------------------
declare portsToForward

function addPort {
    portsToForward[${#portsToForward[@]}]=$1
}

addPort 5432 # postgres
addPort 3000 # grafana
addPort 9090 # prometheus

# help function
# -------------------------------------------------------------------------------------
function Help() {
    echo
    echo "Forward ports in firewall for direct access to various services"
    echo
    echo "Usage:"
    echo "    ${0} [OPTION]"
    echo
    echo "Options:"
    echo "    -f        forward the ports defined in the script (see below)"
    echo "    -p PORT   forward a port supplied from the command line"
    echo "    -h        show this help message"
    echo
    echo "List of ports being temporarily forward in the firewall by this script: ${portsToForward[*]}"
    echo
    echo
    echo "Examples:"
    echo "-> Forward all the above ports"
    echo "    ${0} -f"
    echo
    echo "-> Forward a port supplied from the command line"
    echo "    ${0} -p 3306"
}

# prettyLog
# -------------------------------------------------------------------------------------
function prettyLog() {
    TIMESTAMP=$(date +"%F %T.%3N %z")
    LEVEL=$1
    MESSAGE=$2

    printf "%s [%5s] %s.\n" "${TIMESTAMP}" "${LEVEL}" "${MESSAGE}"
}

# forward ports that are predefined in the script
# -------------------------------------------------------------------------------------
function forwardPorts() {
    commandString="firewall-cmd --quiet"
    for port in "${portsToForward[@]}"; do
        commandString+=" --add-port=${port}/tcp"
    done

    # execute the command
    eval "${commandString}"

    # don't persist the changes
    # firewall-cmd --quiet --runtime-to-permanent
    # firewall-cmd --quiet --reload

    prettyLog "INFO" "Success"
}

# forward a port supplied from the command line
# -------------------------------------------------------------------------------------
function forwardPort() {
    port=$1
    if [[ -z "$port" ]]; then
        prettyLog "ERROR" "No port supplied"
        return 1
    fi

    if ! [[ "$port" =~ ^[0-9]+$ ]] || ((port < 1 || port > 65535)); then
        prettyLog "ERROR" "Invalid port number: $port"
        return 1
    fi

    commandString="firewall-cmd --quiet --add-port=${port}/tcp"

    # execute the command
    eval "${commandString}"

    # don't persist the changes
    # firewall-cmd --quiet --runtime-to-permanent
    # firewall-cmd --quiet --reload

    prettyLog "INFO" "Port ${port} forwarded successfully"
}

# driver code
# -------------------------------------------------------------------------------------
while getopts ":hfp:" opt; do
    case "$opt" in
    h)
        Help
        exit
        ;;
    f)
        forwardPorts
        exit
        ;;
    p)
        if [[ -z "$OPTARG" ]]; then
            prettyLog "ERROR" "No port supplied"
            Help
            exit
        fi
        forwardPort "$OPTARG"
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
