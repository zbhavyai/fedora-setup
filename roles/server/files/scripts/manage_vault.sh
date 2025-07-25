#!/bin/bash
#
# author        : github.com/zbhavyai
# description   : List all vault secrets, or clean them

CURR_SCRIPT=$(readlink -f "$0")
CURR_SCRIPT_PATH=$(dirname "${CURR_SCRIPT}")

# help function
# -------------------------------------------------------------------------------------
function Help() {
    echo
    echo "Usage: ${0} [-l] [-d] [-h]"
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
}

# prettyPrint
# -------------------------------------------------------------------------------------
function prettyPrint() {
    echo -e "$1."
}

# separator printer
# -------------------------------------------------------------------------------------
function printSeparator() {
    terminal_width=$(tput cols)
    printf "%.0s-" $(seq 1 ${terminal_width})
    printf "\n"
}

# list vault secrets
# -------------------------------------------------------------------------------------
function listSecrets() {
    local atleastOneSecret=0
    for key in $(vault kv list --format=json secret | jq -r '.[]'); do
        printSeparator "-"
        atleastOneSecret=1

        printf "Secret: $key\n"
        printf "Value : $(vault kv get --format=json "secret/$key" | jq -c .data.data)\n"
    done

    if [ $atleastOneSecret -eq 0 ]; then
        prettyPrint "[ INFO] No secrets found"
    else
        printSeparator "-"
    fi
}

# delete vault secrets
# -------------------------------------------------------------------------------------
function deleteSecrets() {
    export VAULT_ADDR="http://127.0.0.1:8200"
    export VAULT_TOKEN=$(cat /usr/share/userful-vault/vault_root_token.txt)

    SECRET_LIST=$(curl --silent --show-error --header "X-Vault-Token: ${VAULT_TOKEN}" --request LIST --location "${VAULT_ADDR}/v1/secret/metadata")

    if [[ $? -ne 0 ]]; then
        prettyPrint "[ERROR] Failed to delete secrets from vault"
        return
    fi

    PARSED_SECRET_LIST=$(echo $SECRET_LIST | jq -r .data.keys[] 2>/dev/null)

    if [[ $? -ne 0 ]]; then
        prettyPrint "[ INFO] Didn't find any secrets to delete"
        return
    fi

    for key in $(echo "${PARSED_SECRET_LIST}"); do
        curl --silent --show-error --fail --header "X-Vault-Token: ${VAULT_TOKEN}" --request DELETE --location "${VAULT_ADDR}/v1/secret/metadata/${key}"
    done

    prettyPrint "[ INFO] Secrets deleted"
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
        prettyPrint "[ERROR] Invalid option"
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
