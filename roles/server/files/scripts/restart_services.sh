#!/bin/bash
#
# author        : github.com/zbhavyai
# description   : Restart various services, while clean the data and trimming logs
# help          : ./restart_services.sh -h

CURR_SCRIPT=$(readlink -f "$0")
CURR_SCRIPT_PATH=$(dirname "${CURR_SCRIPT}")
CURR_SCRIPT_VERSION="1.0.0"

# service list that needs to be restarted
# -------------------------------------------------------------------------------------
declare -a SERVICE_LIST
SERVICE_LIST+=("userful-chronos-initial-setup.service")
SERVICE_LIST+=("userful-chronos-aether.service")
SERVICE_LIST+=("userful-chronos-ve.service")
SERVICE_LIST+=("userful-veo.service")
SERVICE_LIST+=("userful-display-manager.service")
SERVICE_LIST+=("userful-grafana.service")

# help function
# -------------------------------------------------------------------------------------
function Help() {
    echo
    echo "Usage: ${0} [-c] [-t] [-s] [-r] [-h]"
    echo
    echo "Options:"
    echo "    -c    clean the database and the vault"
    echo "    -t    trim all the log files"
    echo "    -s    stop the services"
    echo "    -r    restart the services"
    echo "    -h    Show this help message and exit."
    echo "    -v    Show the version of this script."
    echo
    echo "List of services controlled by this script:"
    for service in "${SERVICE_LIST[@]}"; do
        echo "    $service"
    done
    echo
    echo "Examples:"
    echo "-> Clean the database and vault, trim the logs, and restart the services"
    echo "    ${0} -ctr"
    echo
    echo "-> Just trim the logs"
    echo "    ${0} -t"
}

# prettyPrint
# -------------------------------------------------------------------------------------
function prettyPrint() {
    echo -e "$1."
}

# Stop the services
# -------------------------------------------------------------------------------------
function stopServices() {
    prettyPrint "[ INFO] Stopping services"
    systemctl stop "${SERVICE_LIST[@]}"
}

# Start the services
# -------------------------------------------------------------------------------------
function startServices() {
    prettyPrint "[ INFO] Starting services"
    systemctl start "${SERVICE_LIST[@]}"
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
    prettyPrint "[ INFO] Trimming logs"

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
        prettyPrint "[ INFO] Cleaning the database"
        PGPASSWORD=userful psql -U userful -d userful -c "DROP SCHEMA chronos CASCADE" &>/dev/null
        PGPASSWORD=userful psql -h localhost -U userful -d userful -c "SELECT lo_unlink(oid) FROM pg_largeobject_metadata" &>/dev/null

    else
        prettyPrint "[ WARN] Preserving the database"
    fi
}

# clean the vault
# -------------------------------------------------------------------------------------
function cleanVault() {
    if [[ "$1" = "false" ]]; then
        prettyPrint "[ INFO] Cleaning the vault"

        export VAULT_ADDR="http://127.0.0.1:8200"
        export VAULT_TOKEN=$(cat /usr/share/userful-vault/vault_root_token.txt)

        SECRET_LIST=$(curl --silent --show-error --header "X-Vault-Token: ${VAULT_TOKEN}" --request LIST --location "${VAULT_ADDR}/v1/secret/metadata")

        if [[ $? -ne 0 ]]; then
            prettyPrint "[ERROR] Failed to clean vault"
            return
        fi

        PARSED_SECRET_LIST=$(echo $SECRET_LIST | jq -r .data.keys[] 2>/dev/null)

        if [[ $? -ne 0 ]]; then
            # no secrets to clean
            return
        fi

        for key in $(echo "${SECRET_LIST}"); do
            curl --silent --show-error --fail --header "X-Vault-Token: ${VAULT_TOKEN}" --request DELETE --location "${VAULT_ADDR}/v1/secret/metadata/${key}"
        done

    else
        prettyPrint "[ WARN] Preserving the vault"
    fi
}

# driver code
# -------------------------------------------------------------------------------------
PRESERVE_DATA="true"
TRIM_LOGS="false"
SERVICES_STOP_ONLY="false"
SERVICES_RESTART="false"

if [ "$#" -eq 0 ]; then
    Help
    exit 0
fi

while getopts "hvctsr" opt; do
    case "$opt" in
    h)
        Help
        exit
        ;;
    v)
        echo "${CURR_SCRIPT_VERSION}"
        exit
        ;;
    c)
        PRESERVE_DATA="false"
        ;;
    t)
        TRIM_LOGS="true"
        ;;
    s)
        SERVICES_STOP_ONLY="true"
        ;;
    r)
        SERVICES_RESTART="true"
        ;;
    \?)
        prettyPrint "[ERROR] Invalid option"
        Help
        exit
        ;;
    esac
done

if [[ "${SERVICES_STOP_ONLY}" = "true" || "${SERVICES_RESTART}" = "true" ]]; then
    stopServices
fi

if [[ "${TRIM_LOGS}" = "true" ]]; then
    trimLogs
fi

cleanDB "${PRESERVE_DATA}"
cleanVault "${PRESERVE_DATA}"

if [[ "${SERVICES_RESTART}" = "true" ]]; then
    startServices
fi
