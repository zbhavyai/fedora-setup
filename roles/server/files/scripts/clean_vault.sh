#!/bin/bash
#
# author        : bhavyai
# description   : removes all the credentials stored in vault
# how to run    : ./clean_vault.sh

export VAULT_ADDR="http://127.0.0.1:8200"
export VAULT_TOKEN=$(cat /usr/share/userful-vault/vault_root_token.txt)

SECRET_LIST=$(curl -s -H "X-Vault-Token: ${VAULT_TOKEN}" -X LIST ${VAULT_ADDR}/v1/secret/metadata | jq -r .data.keys[] 2>/dev/null)

if [[ $? -ne 0 ]]; then
    echo "[WARN] Unable to fetch secrets. Probably vault is already clean"
    exit 1
fi

for key in $(echo "${SECRET_LIST}"); do
    curl --silent -H "X-Vault-Token: ${VAULT_TOKEN}" -X DELETE ${VAULT_ADDR}/v1/secret/metadata/${key}
done

echo "[INFO] Vault cleaned"
