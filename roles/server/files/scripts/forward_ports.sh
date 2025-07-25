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
    echo "Usage: ${0} [-f] [-h]"
    echo
    echo "Options:"
    echo "    -f    forward the ports"
    echo "    -h    show this help message"
    echo
    echo
    echo "List of ports being temporarily forward in the firewall by this script: ${portsToForward[@]}"
    echo
    echo "Examples:"
    echo "-> Forward all the above ports"
    echo "    ${0} -f"
}

# prettyPrint
# -------------------------------------------------------------------------------------
function prettyPrint() {
    echo -e "$1."
}

# forward ports
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

    prettyPrint "[ INFO] Success"
}

# driver code
# -------------------------------------------------------------------------------------
while getopts ":hf" opt; do
    case "$opt" in
    h)
        Help
        exit
        ;;
    f)
        forwardPorts
        ;;
    \?)
        prettyPrint "[ERROR] Invalid option"
        Help
        exit
        ;;
    esac
done

if ((OPTIND == 1)); then
    Help
    exit
fi
