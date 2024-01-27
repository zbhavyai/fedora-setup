#!/bin/bash
# Author        : github.com/zbhavyai
# Purpose       : List all KV2 secrets from Hashicorp Vault


SCRIPT_DIR="$(dirname "$0")"
ROOT_TOKEN="${SCRIPT_DIR}/vault_root_token.txt"

initVault() {
    export VAULT_ADDR="http://127.0.0.1:8200"

    if [ -f "${ROOT_TOKEN}" ]; then
        export VAULT_TOKEN=$(cat "${ROOT_TOKEN}")
    fi
}
export -f initVault


listVaultSecrets() {
    local atleastOneSecret=0

    for key in $(vault kv list --format=json secret | jq -r '.[]'); do
        printSeparator "-"
        atleastOneSecret=1

        printf "Secret: $key\n"
        printf "Value : $(vault kv get --format=json "secret/$key" | jq -c .data.data)\n"
    done

    if [ $atleastOneSecret -eq 0 ]; then
        printf "No secrets found\n"
    else
        printSeparator "-"
    fi
}
export -f listVaultSecrets


main() {
    initVault
    listVaultSecrets
}

main
