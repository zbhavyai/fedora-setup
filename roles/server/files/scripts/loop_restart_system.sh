#!/bin/bash
#
# author        : bhavyai
# description   : restart whole system
# how to run    : ./remove_grafana.sh

# basic setup
TOTAL_RESTART_FILE="${PWD}/restarts_total.txt"
CURRENT_RESTART_FILE="${PWD}/restarts_current.txt"
TOTAL_RESTARTS=0
CURRENT_RESTART=0
regex='^[0-9]+$'
LOGFILE="${PWD}/system_restarter_loop.log"
mkdir -p "${PWD}/system_restarter_loop_logs/"

# check the total restarts
if [ -f "${TOTAL_RESTART_FILE}" ]; then
    TOTAL_RESTARTS=$(cat "${TOTAL_RESTART_FILE}")
else
    printf "[ERROR] %s not found\n" "${TOTAL_RESTART_FILE}" | tee -a "${LOGFILE}"
    exit 1
fi

# check the current restart
if [ -f "${CURRENT_RESTART_FILE}" ]; then
    CURRENT_RESTART=$(cat "${CURRENT_RESTART_FILE}")
else
    echo "0" >"${CURRENT_RESTART_FILE}"
fi

# verify the restart count
if ! [[ ${TOTAL_RESTARTS} =~ ${regex} ]]; then
    printf "[ERROR] Invalid number of total restarts\n" | tee -a "${LOGFILE}"
    exit 1
elif ! [[ ${CURRENT_RESTART} =~ ${regex} ]]; then
    printf "[ERROR] Invalid number of current restart\n" | tee -a "${LOGFILE}"
    exit 1
elif [ "${CURRENT_RESTART}" -eq "${TOTAL_RESTARTS}" ]; then
    printf "[ERROR] Script done\n"
    exit 1
fi

# update restart count for next iteration
NEXT_COUNT=$((CURRENT_RESTART + 1))
echo "${NEXT_COUNT}" >"${CURRENT_RESTART_FILE}"

printf " [INFO] Current Restart count = %s\n" "${CURRENT_RESTART}" | tee -a "${LOGFILE}"

# save current logs
cp "/var/log/userful/userful-chronos-ve.log" "${PWD}/system_restarter_loop_logs/"
mv "${PWD}/system_restarter_loop_logs/userful-chronos-ve.log" "${PWD}/system_restarter_loop_logs/userful-chronos-ve_${CURRENT_RESTART}.log"
printf " [INFO] Logs saved\n" | tee -a "${LOGFILE}"

# save the status
systemctl status userful-chronos-ve.service >"${PWD}/system_restarter_loop_logs/userful-chronos-ve_${CURRENT_RESTART}.status"
printf " [INFO] Service status saved\n" | tee -a "${LOGFILE}"

# trim the logs
cat /dev/null >/var/log/userful/userful-chronos-ve.log
printf " [INFO] Old logs trimmed\n" | tee -a "${LOGFILE}"

# restart the system
printf " [INFO] Restarting system\n" | tee -a "${LOGFILE}"
/usr/sbin/shutdown -r 0
