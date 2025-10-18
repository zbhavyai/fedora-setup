#!/bin/bash
#
# author        : Martin Kamneng
# description   : Update Keycloak client origins to allow local ReactJS development

CURR_SCRIPT=$(readlink -f "$0")
CURR_SCRIPT_PATH=$(dirname "${CURR_SCRIPT}")

# configuration
# -------------------------------------------------------------------------------------
CLIENT_ID="userful-chronos-aether"

# prettyLog
# -------------------------------------------------------------------------------------
function prettyLog() {
    TIMESTAMP=$(date +"%F %T.%3N %z")
    LEVEL=$1
    MESSAGE=$2

    printf "%s [%5s] %s.\n" "${TIMESTAMP}" "${LEVEL}" "${MESSAGE}"
}

# execSQL
# -------------------------------------------------------------------------------------
function execSQL() {
    local query="$1"
    PGPASSWORD=userful psql -h localhost -U userful -d keycloak -c "$query"
}

# driver code
# -------------------------------------------------------------------------------------
prettyLog "INFO" "Adding web_origins and redirect_uris"

# insert web_origins
execSQL "
INSERT INTO web_origins (client_id, value)
SELECT T1.id, T2.value
FROM client T1, (
    VALUES
        ('http://localhost:3000'),
        ('http://localhost:3000/*')
) AS T2(value)
WHERE T1.client_id = '$CLIENT_ID'
ON CONFLICT DO NOTHING;"

# insert redirect_uris
execSQL "
INSERT INTO redirect_uris (client_id, value)
SELECT id, 'http://localhost:3000/*'
FROM client WHERE client_id = '$CLIENT_ID'
ON CONFLICT DO NOTHING;"

# restart keycloak
systemctl restart userful-keycloak.service
prettyLog "INFO" "Update complete."
