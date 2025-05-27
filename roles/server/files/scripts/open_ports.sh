#!/bin/bash
#
# author        : bhavyai
# description   : open ports for various services
# how to run    : ./open_ports.sh

# array to store ports to open
declare portsToOpen

# function to update array
function addPort {
    portsToOpen[${#portsToOpen[@]}]=$1
}

# populate the array
addPort 5432 # postgres
addPort 3000 # grafana
addPort 9090 # prometheus

# create the command
commandString="firewall-cmd -q"
for port in "${portsToOpen[@]}"; do
    commandString+=" --add-port=${port}/tcp"
done

# execute the command
eval "${commandString}"
