#!/bin/bash
#
# author        : bhavyai
# description   : creates a user with sudo privileges and prompts for password
# how to run    : ./create_user.sh

PROGNAME="$(basename "$0")"

# help function
# -------------------------------------------------------------------------------------
function Help() {
    # Help: function to display usage

    echo
    echo "Usage:"
    echo "./${PROGNAME} -n <USERNAME>"
    echo
    echo "Options:"
    echo "n     New username"
    echo "h     Print this Help"
    echo
}

# create user function
# -------------------------------------------------------------------------------------
function createUser() {
    USERNAME=${1}

    # create user
    useradd --create-home ${USERNAME} --groups wheel
}

# create password function
# -------------------------------------------------------------------------------------
function setPassword() {
    USERNAME=${1}

    # set password
    passwd ${USERNAME}
}

# driver code
# -------------------------------------------------------------------------------------
while getopts ":n:h" option; do
    case "${option}" in
    h) # display usage
        Help
        exit
        ;;
    n) # username
        USERNAME=${OPTARG}
        ;;
    \?) # invalid option
        Help
        exit
        ;;
    esac
done

if ((OPTIND == 1)); then
    Help
    exit
fi

if [[ -z "${USERNAME}" ]]; then
    Help
    exit
fi

# create user, and if successful create password
if ! createUser "${USERNAME}"; then
    echo "Error: failed to create user ${USERNAME}" >&2
    exit 1
else
    setPassword "${USERNAME}"
fi
