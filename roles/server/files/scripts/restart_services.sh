#!/bin/bash
#
# author        : bhavyai
# description   : trim the logs, cleans the database and restart the three main services
# how to run    : ./restart_services.sh       : restarts the services

SERVICE_LIST="userful-chronos-initial-setup.service userful-chronos-keycloak-main.service userful-chronos-aether.service userful-chronos-ve.service userful-veo.service userful-display-manager.service userful-grafana.service"

# help function
# -------------------------------------------------------------------------------------
function Help() {
    echo
    echo "Usage: ${0} [-p] [-c] [-s] [-t] [-h]"
    echo
    echo "Options:"
    echo "  -p  Preserve the database and the vault. This is the default behavior."
    echo "  -c  Don't preserve the data. Clean the database and the vault."
    echo "  -s  Don't start the services. Useful when some manual steps are required before starting the services."
    echo "  -t  Just trim the logs, don't do anything else."
    echo "  -h  Show this help message and exit."
    echo
}

# Stop the services
# -------------------------------------------------------------------------------------
function stopServices() {
    echo "[ INFO] Stopping services"
    systemctl stop ${SERVICE_LIST}

    if [ $? -ne 0 ]; then
        echo "[FATAL] Unable to stop services"
        exit 1
    fi
}

# Start the services
# -------------------------------------------------------------------------------------
function startServices() {
    echo "[ INFO] Starting services"
    systemctl start ${SERVICE_LIST}

    if [ $? -ne 0 ]; then
        echo "[FATAL] Unable to start services"
        exit 1
    fi
}

# trim the logs
# -------------------------------------------------------------------------------------
function removeLogFiles() {
    rm -f $1.* $1-*
    cat /dev/null >$1
}

function removeXorgLogFiles() {
    rm -f "$@"
}

function trimLogs() {
    echo "[ INFO] Trimming logs"

    # chronos logs
    removeLogFiles /var/log/userful/userful-chronos-aether.log
    removeLogFiles /var/log/userful/userful-chronos-ve.log

    # keycloak and usrmgt logs
    removeLogFiles /var/log/userful/userful-chronos-keycloak.log
    removeLogFiles /var/log/userful/userful-chronos-keycloak-app.log

    # veo and udm logs
    removeLogFiles /var/log/userful/veo.log
    removeLogFiles /var/log/userful/veo-stderr.log
    removeLogFiles /var/log/userful/veo-stdout.log
    removeLogFiles /var/log/userful/display-manager.log

    # init and backup logs
    removeLogFiles /var/log/userful/userful-chronos-initial-setup.log
    removeLogFiles /var/log/userful/db_backup_and_restore.log
    removeLogFiles /var/log/userful/vault_backup_and_restore.log

    # plugin logs
    removeLogFiles /var/log/userful/profile-data.log

    # nginx logs
    removeLogFiles /var/log/userful/web-service-access.log
    removeLogFiles /var/log/userful/web-service-error.log

    # xorg logs
    removeXorgLogFiles /var/log/Xorg*log
}

# remove all logs
# -------------------------------------------------------------------------------------
function removeAllLogs() {
    LOG_DIRECTORY="/var/log/userful/"

    # remove all logs
    find ${LOG_DIRECTORY} -type f -name "*.log*" -exec rm -f {} \;

    # remove all empty directories
    find ${LOG_DIRECTORY} -mindepth 1 -empty -type d -delete

    # remove all broken links
    find -L ${LOG_DIRECTORY} -maxdepth 1 -type l -delete
}

# clean the database
# -------------------------------------------------------------------------------------
function cleanDB() {
    if [[ "$1" = "false" ]]; then
        echo "[ INFO] Cleaning the database"
        PGPASSWORD=userful psql -U userful -d userful -c "DROP SCHEMA chronos CASCADE" &>/dev/null
        PGPASSWORD=userful psql -h localhost -U userful -d userful -c "SELECT lo_unlink(oid) FROM pg_largeobject_metadata" &>/dev/null

    else
        echo "[ WARN] Preserving the database"
    fi
}

# clean the vault
# -------------------------------------------------------------------------------------
function cleanVault() {
    if [[ "$1" = "false" ]]; then
        echo "[ INFO] Cleaning the vault"

        export VAULT_ADDR="http://127.0.0.1:8200"
        export VAULT_TOKEN=$(cat /usr/share/userful-vault/vault_root_token.txt)

        SECRET_LIST=$(curl --silent --header "X-Vault-Token: ${VAULT_TOKEN}" --request LIST ${VAULT_ADDR}/v1/secret/metadata | jq -r .data.keys[] 2>/dev/null)

        if [[ $? -ne 0 ]]; then
            return
        fi

        for key in $(echo "${SECRET_LIST}"); do
            curl --silent --header "X-Vault-Token: ${VAULT_TOKEN}" --request DELETE ${VAULT_ADDR}/v1/secret/metadata/${key}
        done

    else
        echo "[ WARN] Preserving the vault"
    fi
}

# driver code
# -------------------------------------------------------------------------------------
preserveData=true
stopOnly=false
trimLogsOnly=false

# Parse command-line options
while getopts "psthc" opt; do
    case "$opt" in
    p) # don't clean the database and vault
        preserveData=true
        ;;
    c) # clean the database and vault
        preserveData=false
        ;;
    s) # stop services only, don't start
        stopOnly=true
        ;;
    t) # trim logs only, don't do anything else
        trimLogsOnly=true
        ;;
    h) # display usage
        Help
        exit
        ;;
    \?) # Invalid option
        Help
        exit
        ;;
    esac
done

if [[ "$trimLogsOnly" = "true" ]]; then
    trimLogs
    exit
else
    stopServices
    trimLogs
fi

if [[ "$preserveData" = "false" ]]; then
    cleanDB $preserveData
    cleanVault $preserveData
fi

if [[ "$stopOnly" = "false" ]]; then
    startServices
fi
