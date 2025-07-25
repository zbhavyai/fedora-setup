#!/bin/bash
#
# author        : github.com/zbhavyai
# description   : Creates a user with sudo privileges and prompts for password

CURR_SCRIPT=$(readlink -f "$0")
CURR_SCRIPT_PATH=$(dirname "${CURR_SCRIPT}")

# help function
# -------------------------------------------------------------------------------------
function Help() {
    echo
    echo "Usage: ${0} [-n USERNAME] [-h]"
    echo
    echo "Options:"
    echo "    -n USERNAME   new user to create"
    echo "    -h            show this help message"
    echo
    echo
    echo "Examples:"
    echo "-> Create a new user called clove"
    echo "    ${0} -n clove"
}

# prettyPrint
# -------------------------------------------------------------------------------------
function prettyPrint() {
    echo -e "$1."
}

# create user function
# -------------------------------------------------------------------------------------
function createUser() {
    local USERNAME=${1}

    if id -u "$USERNAME" &>/dev/null; then
        prettyPrint "[ERROR] '$USERNAME' already exists"
        return 1
    fi
    useradd --create-home ${USERNAME} --groups wheel
}

# create password function
# -------------------------------------------------------------------------------------
function setPassword() {
    local USERNAME=${1}
    passwd ${USERNAME}
}

# driver code
# -------------------------------------------------------------------------------------
while getopts ":n:h" option; do
    case "${option}" in
    h)
        Help
        exit
        ;;
    n)
        USERNAME=${OPTARG}
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

if [[ -z "${USERNAME}" ]]; then
    prettyPrint "[ERROR] Username can't be empty"
    exit
fi

if ! createUser "${USERNAME}"; then
    prettyPrint "[ERROR] Failed to create user ${USERNAME}"
    exit 1
else
    setPassword "${USERNAME}"
fi
