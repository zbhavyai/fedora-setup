#!/bin/bash
#
# author        : bhavyai
# description   : restart userful-chronos-ve multiple times in a loop
# how to run    : ./ve_restarter_loop.sh <restart count> yes|no

# basic setup
RESTARTS=1
regex='^[0-9]+$'
LOGFILE="${PWD}/ve_restarter_loop.log"
mkdir -p "${PWD}/ve_restarter_loop_logs/"

# Get the restart count
if [ $# -ne 2 ]; then
    # printf " [WARN] Defaulting to 1 restart\n" | tee -a ${LOGFILE}
    printf "[ERROR] Usage: $0 <restart count> yes|no\n"
    exit 1
elif ! [[ $1 =~ ${regex} ]]; then
    printf "[ERROR] Invalid number of restarts\n"
    exit 1
else
    RESTARTS=$1
    printf " [INFO] Doing ${RESTARTS} restarts\n" | tee -a ${LOGFILE}
fi

# dbus restarter
function dbus_restarter() {
    # restart the dbus
    systemctl restart dbus.socket dbus.service
    printf " [INFO] dbus restarted\n" | tee -a ${LOGFILE}

    # restart the display manager
    systemctl restart userful-display-manager.service
    printf " [INFO] Display manager restarted\n" | tee -a ${LOGFILE}

    # restart the task manager
    systemctl restart userful-task-manager.service
    printf " [INFO] Task manager restarted\n" | tee -a ${LOGFILE}

    # restart the chronos veo
    systemctl restart userful-veo.service
    printf " [INFO] VEO restarted\n" | tee -a ${LOGFILE}
}

# perform the restarts
for i in $(seq 1 ${RESTARTS}); do
    printf " [INFO] Restart count = ${i}/${RESTARTS}\n" | tee -a ${LOGFILE}

    # trim the logs
    >/var/log/userful/userful-chronos-ve.log
    printf " [INFO] Old logs trimmed\n" | tee -a ${LOGFILE}

    # restart dbus if asked
    if [[ "$2" == "yes" ]]; then
        dbus_restarter
    fi

    # restart the ve
    systemctl restart userful-chronos-ve.service
    printf " [INFO] userful-chronos-ve restarted\n" | tee -a ${LOGFILE}

    # sleep for a while
    sleep 10

    # save the logs
    cp "/var/log/userful/userful-chronos-ve.log" "${PWD}/ve_restarter_loop_logs/"
    mv "${PWD}/ve_restarter_loop_logs/userful-chronos-ve.log" "${PWD}/ve_restarter_loop_logs/userful-chronos-ve_${i}.log"
    printf " [INFO] Logs saved\n" | tee -a ${LOGFILE}

    # save the status
    systemctl status userful-chronos-ve.service >"${PWD}/ve_restarter_loop_logs/userful-chronos-ve_${i}.status"
    printf " [INFO] Service status saved\n" | tee -a ${LOGFILE}
done

printf " [INFO] Script finished\n" | tee -a ${LOGFILE}
