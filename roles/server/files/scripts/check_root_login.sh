#!/bin/bash

# Define the configuration file path
config_file="/etc/ssh/sshd_config"

# Check if PermitRootLogin is present and set to yes
if grep -q "^PermitRootLogin yes$" "$config_file"; then
    echo "PermitRootLogin is already set to yes."
else
    # Replace existing PermitRootLogin line with PermitRootLogin yes
    sed -i 's/^#*PermitRootLogin .*/PermitRootLogin yes/' "$config_file"
    echo "PermitRootLogin set to yes."

    # Restart sshd service
    systemctl restart sshd
    echo "sshd service restarted."
fi
