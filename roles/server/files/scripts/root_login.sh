#!/bin/bash
#
# author        : github.com/zbhavyai
# description   : Enable root login to the server using password authentication.
# help          : ./root_login.sh -h

CURR_SCRIPT=$(readlink -f "$0")
CURR_SCRIPT_PATH=$(dirname "${CURR_SCRIPT}")

# help function
# -------------------------------------------------------------------------------------
function Help() {
    echo
    echo "Usage: ${0} [-e] [-h]"
    echo
    echo "Options:"
    echo "    -e    enable root password login to the server. Use passwd to set root password"
    echo "    -h    show this help message"
    echo
    echo
    echo "Examples:"
    echo "-> Run the script"
    echo "    ${0} -e"
    echo
    echo "-> Try ssh now (assuming root password is set)"
    echo "    ssh -o PreferredAuthentications=password root@192.168.XXX.XXX -p PORT"
}

# prettyPrint
# -------------------------------------------------------------------------------------
function prettyPrint() {
    echo -e "$1."
}

# enable logging in using password (use passwd to set root password)
# -------------------------------------------------------------------------------------
function enableRootPasswordLogin() {
    local SSH_CONFIG="/etc/ssh/sshd_config"
    local USERFUL_CONF="/etc/ssh/sshd_config.d/40-userful.conf"

    # allow root login
    if grep -qE "^\s*PermitRootLogin\s+yes\s*$" "$SSH_CONFIG"; then
        prettyPrint "[ INFO] PermitRootLogin is already set to yes in $SSH_CONFIG"
    else
        if grep -qE "^\s*PermitRootLogin\s+" "$SSH_CONFIG"; then
            sed -i 's/^\s*PermitRootLogin\s\+.*/PermitRootLogin yes/' "$SSH_CONFIG"
            prettyPrint "[ INFO] Updated PermitRootLogin to yes in $SSH_CONFIG"
        else
            echo "PermitRootLogin yes" >>"$SSH_CONFIG"
            prettyPrint "[ INFO] Appended PermitRootLogin yes to $SSH_CONFIG"
        fi
    fi

    # allow password authentication
    if grep -qE "^\s*PasswordAuthentication\s+yes\s*$" "$USERFUL_CONF"; then
        prettyPrint "[ INFO] PasswordAuthentication already set to yes in $USERFUL_CONF"
    else
        if grep -qE "^\s*PasswordAuthentication\s+" "$USERFUL_CONF"; then
            sed -i 's/^\s*PasswordAuthentication\s\+.*/PasswordAuthentication yes/' "$USERFUL_CONF"
            prettyPrint "[ INFO] Updated PasswordAuthentication to yes in $USERFUL_CONF"
        else
            echo "PasswordAuthentication yes" >>"$USERFUL_CONF"
            prettyPrint "[ INFO] Appended PasswordAuthentication yes to $USERFUL_CONF"
        fi
    fi

    # restart services
    systemctl restart sshd
    prettyPrint "[ INFO] sshd service restarted"
}

# driver code
# -------------------------------------------------------------------------------------
while getopts "he" opt; do
    case "$opt" in
    h)
        Help
        exit
        ;;
    e)
        enableRootPasswordLogin
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
