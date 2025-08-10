#!/bin/bash
#
# author        : github.com/zbhavyai
# description   : List all vault secrets, or clean them

CURR_SCRIPT=$(readlink -f "$0")
CURR_SCRIPT_PATH=$(dirname "${CURR_SCRIPT}")

VAULT_ADDR="http://127.0.0.1:8200"
VAULT_TOKEN_FILE="/usr/share/userful-vault/vault_root_token.txt"
VAULT_TOKEN="$(<"$VAULT_TOKEN_FILE")"
export VAULT_ADDR
export VAULT_TOKEN

# help function
# -------------------------------------------------------------------------------------
function Help() {
    echo
    echo "List all vault secrets, or clean them"
    echo
    echo "Usage:"
    echo "    ${0} [OPTION]"
    echo
    echo "Options:"
    echo "    -l    list all secrets stored in the vault"
    echo "    -d    delete all secrets stored in the vault"
    echo "    -h    show this help message"
    echo
    echo
    echo "Examples:"
    echo "-> List all secrets"
    echo "    ${0} -l"
    echo
    echo "-> Delete all secrets"
    echo "    ${0} -d"
    echo
}

# prettyLog
# -------------------------------------------------------------------------------------
function prettyLog() {
    TIMESTAMP=$(date +"%F %T.%3N %z")
    LEVEL=$1
    MESSAGE=$2

    printf "%s [%5s] %s.\n" "${TIMESTAMP}" "${LEVEL}" "${MESSAGE}"
}

# separator printer
# -------------------------------------------------------------------------------------
function printSeparator() {
    terminal_width=$(tput cols)
    printf "%.0s-" $(seq 1 "${terminal_width}")
    printf "\n"
}

# list vault secrets
# -------------------------------------------------------------------------------------
function listSecrets() {
    local atleastOneSecret=0
    for key in $(vault kv list --format=json secret | jq -r '.[]'); do
        printSeparator "-"
        atleastOneSecret=1

        printf "Secret: %s\n" "${key}"
        value="$(vault kv get --format=json "secret/${key}" | jq -c '.data.data')"
        printf "Value : %s\n" "${value}"
    done

    if [ $atleastOneSecret -eq 0 ]; then
        prettyLog "INFO" "No secrets found"
    else
        printSeparator "-"
    fi
}

# delete vault secrets
# -------------------------------------------------------------------------------------
function deleteSecrets() {
    SECRET_LIST=$(curl --silent --show-error --header "X-Vault-Token: ${VAULT_TOKEN}" --request LIST --location "${VAULT_ADDR}/v1/secret/metadata")

    if ! echo "${SECRET_LIST}" >/dev/null; then
        prettyLog "ERROR" "Failed to fetch secrets from vault"
        return 1
    fi

    PARSED_SECRET_LIST=$(echo "${SECRET_LIST}" | jq -r .data.keys[] 2>/dev/null)

    if [ -z "${PARSED_SECRET_LIST}" ]; then
        prettyLog "INFO" "Didn't find any secrets to delete"
        return 0
    fi

    for key in ${PARSED_SECRET_LIST}; do
        curl --silent --show-error --fail --header "X-Vault-Token: ${VAULT_TOKEN}" --request DELETE --location "${VAULT_ADDR}/v1/secret/metadata/${key}"
    done

    prettyLog "INFO" "Secrets deleted"
}

# driver code
# -------------------------------------------------------------------------------------
LIST_SECRETS="false"
DELETE_SECRETS="false"

while getopts ":hld" opt; do
    case "$opt" in
    h)
        Help
        exit
        ;;
    l)
        LIST_SECRETS="true"
        ;;
    d)
        DELETE_SECRETS="true"
        ;;
    \?)
        prettyLog "ERROR" "Invalid option"
        Help
        exit
        ;;
    esac
done

if ((OPTIND == 1)); then
    Help
    exit
fi

if [[ "${LIST_SECRETS}" = "true" ]]; then
    listSecrets
fi

if [[ "${DELETE_SECRETS}" = "true" ]]; then
    deleteSecrets
fi
