#!/bin/bash
#
# author        : github.com/zbhavyai
# description   : Open remote PostgreSQL access, dump database schema/data, or load SQL into chronos schema.

CURR_SCRIPT=$(readlink -f "$0")
CURR_SCRIPT_PATH=$(dirname "${CURR_SCRIPT}")

# help function
# -------------------------------------------------------------------------------------
function Help() {
    echo
    echo "Open remote PostgreSQL access, dump database schema/data, or load SQL into chronos schema."
    echo
    echo "Usage:"
    echo "    ${0} [OPTION]"
    echo
    echo "Options:"
    echo "    -o                open PostgreSQL for remote connections"
    echo "    -l <filename>     load given SQL file into 'chronos' schema"
    echo "    -d <filename>     dump schema+data of 'chronos' schema to file"
    echo "    -s <filename>     dump schema only to file"
    echo "    -h                show this help message"
    echo
    echo
    echo "Examples:"
    echo "-> Open postgres for remote connections"
    echo "    ${0} -o"
    echo
    echo "    and then you can connect directly from your laptop using cmd or pgAdmin, like"
    echo "    PGPASSWORD=userful psql -h 192.168.123.98 -U userful -d userful"
    echo
}

# prettyPrint
# -------------------------------------------------------------------------------------
function prettyPrint() {
    echo -e "$1."
}

# check if a line exists in a file
# -------------------------------------------------------------------------------------
function lineExists() {
    grep -Fxq "$1" "$2"
}

# open postgres for remote connections
# -------------------------------------------------------------------------------------
function openPostgres() {
    local config_file="/var/lib/pgsql/data/postgresql.conf"
    local listen_address="listen_addresses = '*'"

    if ! lineExists "$listen_address" "$config_file"; then
        sed -i "s/^#listen_addresses\s*=.*/$listen_address/" "$config_file"
    fi

    local pg_hba_conf="/usr/share/userful-postgresql/pg_hba.conf"
    local ipv4_rule="host    all             all              0.0.0.0/0              md5"
    local ipv6_rule="host    all             all              ::/0                   md5"

    if ! lineExists "$ipv4_rule" "$pg_hba_conf"; then
        sed -i 's/peer/trust/' "$pg_hba_conf"
        echo "$ipv4_rule" >>"$pg_hba_conf"
        echo "$ipv6_rule" >>"$pg_hba_conf"
    fi

    systemctl restart userful-postgresql.service

    if ! (firewall-cmd --list-ports | grep -wq "5432"); then
        firewall-cmd -q --add-port=5432/tcp
        firewall-cmd -q --runtime-to-permanent
        firewall-cmd -q --reload
    fi

    prettyPrint "[INFO] PostgreSQL is now open for remote connections."
}

# load a SQL script to userful database in chronos schema
# -------------------------------------------------------------------------------------
function loadSQL() {
    local sql_file="$1"
    local HOST="localhost"
    local USER="userful"
    local PASS="userful"
    local DB="userful"

    if [[ ! -f "$sql_file" ]]; then
        echo "[ERROR] SQL file not found: $sql_file"
        exit 1
    fi

    PGPASSWORD="$PASS" PGOPTIONS="--search_path=chronos" \
        psql -h "$HOST" -U "$USER" -d "$DB" -f "$sql_file"
    prettyPrint "[INFO] SQL script loaded from $sql_file"
}

# dump postgres schema
# -------------------------------------------------------------------------------------
function dumpPostgresSchema() {
    local filename="$1"
    local with_data="$2"
    local HOST="localhost"
    local USER="userful"
    local PASS="userful"
    local DB="userful"

    if [[ "$with_data" == "no" ]]; then
        PGPASSWORD="$PASS" pg_dump -h "$HOST" -U "$USER" -s "$DB" -f "$filename"
    else
        PGPASSWORD="$PASS" pg_dump -h "$HOST" -U "$USER" -d "$DB" -n chronos -f "$filename"
    fi

    if [[ $? -eq 0 ]]; then
        prettyPrint "[INFO] Dump successful: $filename"
    else
        prettyPrint "[ERROR] Failed to dump database"
        exit 1
    fi
}

# driver code
# -------------------------------------------------------------------------------------
while getopts ":ol:d:s:h" opt; do
    case "$opt" in
    o)
        openPostgres
        ;;
    l)
        loadSQL "$OPTARG"
        ;;
    d)
        dumpPostgresSchema "$OPTARG" "yes"
        ;;
    s)
        dumpPostgresSchema "$OPTARG" "no"
        ;;
    h)
        Help
        ;;
    \?)
        prettyPrint "[ERROR] Invalid option: -$OPTARG"
        Help
        exit 1
        ;;
    :)
        prettyPrint "[ERROR] Option -$OPTARG requires an argument."
        Help
        exit 1
        ;;
    esac
done

if ((OPTIND == 1)); then
    Help
    exit
fi
