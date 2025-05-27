#!/bin/bash
#
# author        : bhavyai
# description   : dump postgres database schema with or without data
# how to run    : ./dump_postgres.sh "filename.sql"
#               : ./dump_postgres.sh "filename.sql" no

HOSTNAME="localhost"
USER="userful"
PASSWORD="userful"
DATABASE="userful"

# check number of arguments
if [ "$#" -eq 0 ]; then
    echo "[ERROR] File name is required"
    exit 1
fi

FILENAME=${1}
WITH_DATA=${2}

if [ "${WITH_DATA}" = "no" ]; then
    PGPASSWORD="${PASSWORD}" pg_dump -h ${HOSTNAME} -U ${USER} -s ${DATABASE} -f ${FILENAME}

    if [ $? -eq 0 ]; then
        echo "[INFO] Database schema dumped in file ${FILENAME}"
    else
        echo "[ERROR] Error in dumping database schema"
    fi
else
    PGPASSWORD="${PASSWORD}" pg_dump -h ${HOSTNAME} -U ${USER} -d ${DATABASE} -n chronos -f ${FILENAME}

    if [ $? -eq 0 ]; then
        echo "[INFO] Database dumped in file ${FILENAME}"
    else
        echo "[ERROR] Error in dumping database"
    fi
fi
