#!/bin/bash
#
# author        : bhavyai
# description   : allow remote connection to postgres

# Function to check if a line exists in a file
line_exists() {
    grep -Fxq "$1" "$2"
}

# Change listen address to all if not already modified
listen_address="listen_addresses = '*'"
config_file="/var/lib/pgsql/data/postgresql.conf"
if ! line_exists "$listen_address" "$config_file"; then
    sed -i "s/^#listen_addresses\s*=.*/$listen_address/" "$config_file"
fi

# Add config to allow remote connections if not already added
pg_hba_conf="/usr/share/userful-postgresql/pg_hba.conf"
ipv4_rule="host    all             all              0.0.0.0/0              md5"
ipv6_rule="host    all             all              ::/0                   md5"
if ! (line_exists "$ipv4_rule" "$pg_hba_conf" && line_exists "$ipv6_rule" "$pg_hba_conf"); then
    sed -i 's/peer/trust/' "$pg_hba_conf"
    echo "$ipv4_rule" >>"$pg_hba_conf"
    echo "$ipv6_rule" >>"$pg_hba_conf"
fi

# restart the service
systemctl restart userful-postgresql.service

# open 5432 port in firewall
if ! (firewall-cmd --list-ports | grep -wq "5432"); then
    firewall-cmd -q --add-port=5432/tcp
    firewall-cmd -q --runtime-to-permanent
    firewall-cmd -q --reload
fi
