#!/bin/bash
#
# author        : bhavyai
# description   : load a SQL file to postgres userful database
# how to run    : ./load_postgres_file.sh "filename.sql"

HOSTNAME="localhost"
USER="userful"
PASSWORD="userful"
DATABASE="userful"

if [[ "$#" -ne 1 ]]; then
    echo "[FATAL] Please specify SQL script"
    exit 1
fi

PGPASSWORD="${PASSWORD}" PGOPTIONS="--search_path=chronos" psql -h ${HOSTNAME} -U ${USER} -d ${DATABASE} -f ${1}
