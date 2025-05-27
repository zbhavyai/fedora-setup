#!/bin/bash
#
# author        : bhavyai
# description   : install vanilla grafana
# how to run    : ./vanilla_grafana.sh

# check its if its userful grafana
INSTALLED_GRAFANA=$(rpm -q grafana)
if [[ $INSTALLED_GRAFANA != *"userful"* ]]; then
    echo "[ INFO] Userful's Grafana is not installed"
    exit 1
fi

# download grafana
wget https://dl.grafana.com/oss/release/grafana-7.5.15-1.x86_64.rpm

PROBLEMATIC_DIRECTORY="/etc/init.d"

if [ -L "$PROBLEMATIC_DIRECTORY" ]; then
    # should be a symbolic link, okay
    :
elif [ -d "$PROBLEMATIC_DIRECTORY" ]; then
    # shouldn't be a directory, remove it
    mv "${PROBLEMATIC_DIRECTORY}" "${PROBLEMATIC_DIRECTORY}.old"
fi

# install dependencies
dnf install -y chkconfig initscripts-service

# remove userful's grafana
sudo rpm --erase --nodeps ${INSTALLED_GRAFANA}

# install vanilla grafana
rpm -i ./grafana-7.5.15-1.x86_64.rpm
