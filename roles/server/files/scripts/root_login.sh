#!/bin/bash
#
# author        : github.com/zbhavyai
# description   : Enable root login to the server.

CURR_SCRIPT=$(readlink -f "$0")
CURR_SCRIPT_PATH=$(dirname "${CURR_SCRIPT}")

# help function
# -------------------------------------------------------------------------------------
function Help() {
    echo
    echo "Enable root login to the server."
    echo
    echo "Usage:"
    echo "    ${0} [OPTION]"
    echo
    echo "Options:"
    echo "    -e    enable root login to the server"
    echo "    -h    show this help message"
    echo
    echo
    echo "Examples:"
    echo "-> Run the script"
    echo "    ${0} -e"
    echo
    echo "-> Try ssh now (assuming root password is set)"
    echo "    ssh -o PreferredAuthentications=password root@192.168.XXX.XXX -p PORT"
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

# enable logging in using password (use passwd to set root password)
# -------------------------------------------------------------------------------------
function enableRootLogin() {
    local SSH_CONFIG="/etc/ssh/sshd_config"
    local USERFUL_CONF="/etc/ssh/sshd_config.d/40-userful.conf"
    local EXTENDED_CONFIG="/etc/ssh/sshd_config.d/00-userful-extended-security.conf"
    local DYNAMIC_USERS_CONF="/etc/ssh/sshd_config.d/userful-ssh-userful.conf"

    for CONF in "$SSH_CONFIG" "$USERFUL_CONF" "$EXTENDED_CONFIG"; do
        if [ ! -f "$CONF" ]; then
            continue
        fi

        # allow root login
        if grep -qE "^\s*PermitRootLogin\s+yes\s*$" "$CONF"; then
            prettyLog "INFO" "PermitRootLogin already set to yes in $CONF"
        else
            if grep -qE "^\s*PermitRootLogin\s+" "$CONF"; then
                sed -i 's/^\s*PermitRootLogin\s\+.*/PermitRootLogin yes/' "$CONF"
                prettyLog "INFO" "Updated PermitRootLogin to yes in $CONF"
            else
                echo "PermitRootLogin yes" >>"$CONF"
                prettyLog "INFO" "Appended PermitRootLogin yes to $CONF"
            fi
        fi

        # allow password authentication
        if grep -qE "^\s*PasswordAuthentication\s+yes\s*$" "$CONF"; then
            prettyLog "INFO" "PasswordAuthentication already set to yes in $CONF"
        else
            if grep -qE "^\s*PasswordAuthentication\s+" "$CONF"; then
                sed -i 's/^\s*PasswordAuthentication\s\+.*/PasswordAuthentication yes/' "$CONF"
                prettyLog "INFO" "Updated PasswordAuthentication to yes in $CONF"
            else
                echo "PasswordAuthentication yes" >>"$CONF"
                prettyLog "INFO" "Appended PasswordAuthentication yes to $CONF"
            fi
        fi
    done

    # remove restrictive ssh allow rules
    if grep -qE "^\s*AllowUsers\s+" "$EXTENDED_CONFIG"; then
        sed -i 's/^\s*AllowUsers\s\+/# AllowUsers /' "$EXTENDED_CONFIG"
        prettyLog "INFO" "Disabled AllowUsers restriction in $EXTENDED_CONFIG"
    fi

    if grep -qE "^\s*AllowGroups\s+" "$EXTENDED_CONFIG"; then
        sed -i 's/^\s*AllowGroups\s\+/# AllowGroups /' "$EXTENDED_CONFIG"
        prettyLog "INFO" "Disabled AllowGroups restriction in $EXTENDED_CONFIG"
    fi

    # remove dynamic users allowance config
    rm -f "$DYNAMIC_USERS_CONF"
    prettyLog "INFO" "Removed $DYNAMIC_USERS_CONF to disable dynamic user restrictions"

    # restart services
    systemctl restart sshd
    prettyLog "INFO" "sshd service restarted"
}

# driver code
# -------------------------------------------------------------------------------------
while getopts ":he" opt; do
    case "$opt" in
    h)
        Help
        exit
        ;;
    e)
        enableRootLogin
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
