#!/bin/bash
# Author        : github.com/zbhavyai
# Purpose       : Install VS Code and its extensions


SCRIPT_DIR="$(dirname "$0")"
EXTS_INSTALL="${SCRIPT_DIR}/install.txt"
FILE_PREF="${HOME}/.config/Code/User/settings.json"
FILE_KB="${HOME}/.config/Code/User/keybindings.json"

setup_repos() {
    # source: https://code.visualstudio.com/docs/setup/linux#_rhel-fedora-and-centos-based-distributions
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
}

install_packages() {
    sudo dnf install -y code
}

create_profile() {
    local PROFILE_NAME="$1"
    printf "[INFO] Creating profile: %s\n" "$PROFILE_NAME"
    code --profile "$PROFILE_NAME" --disable-extensions &
    sleep 5
    pkill -9 -f "code --profile"
}

install_extensions() {
    local PROFILE=""

    while IFS= read -r line || [[ -n "$line" ]]; do
        # Skip empty lines and lines starting with #
        if [[ -z "$line" || "$line" =~ ^#.* ]]; then
            continue
        fi

        if [[ "$line" =~ ^\[([a-zA-Z0-9_-]+)\]$ ]]; then
            PROFILE="${BASH_REMATCH[1]}"

            # if [[ -z "$PROFILE" || "${PROFILE,,}" == "default" ]]; then
            #     :
            # else
            #     create_profile "${PROFILE}"
            # fi
        else
            if [[ -z "$PROFILE" || "${PROFILE,,}" == "default" ]]; then
                printf '[INFO] Install: %s in profile: default\n' "${line}"
                code --install-extension "${line}" 1> /dev/null
            else
                printf '[INFO] Install: %s in profile: %s\n' "${line}" "${PROFILE}"
                code --install-extension "${line}" --profile "${PROFILE}" 1> /dev/null
            fi
        fi
    done < "${EXTS_INSTALL}"

    printf "\n"
}

setup_config() {
    printf '[INFO] Setting up VS Code preferences: %s\n' "${FILE_PREF}"
    cp "${SCRIPT_DIR}/settings.jsonc" "${FILE_PREF}"

    printf "\n"
}

setup_keybindings() {
    printf '[INFO] Setting up VS Code keybindings: %s\n' "${FILE_KB}"
    cp "${SCRIPT_DIR}/keybindings.jsonc" "${FILE_KB}"

    printf "\n"
}


main() {
    setup_repos
    install_packages
    create_profile "JAVA"
    create_profile "PYTHON"
    install_extensions
    setup_config
    setup_keybindings
}

main
