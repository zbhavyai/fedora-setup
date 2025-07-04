# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi

unset rc

# #############################################################################
# determine type of distro
# #############################################################################
export isRhel=1
if [ -f /etc/os-release ]; then
    ID=$(grep -oP '(?<=^ID=).+' /etc/os-release | tr -d '"')
    ID_LIKE=$(grep -oP '(?<=^ID_LIKE=).+' /etc/os-release | tr -d '"')

    if [[ "$ID" == "rhel" || "$ID_LIKE" == *"rhel"* || "$ID" == "fedora" ]]; then
        export isRhel=0
    else
        export isRhel=1
    fi
fi

# #############################################################################
# determine type of shell
# #############################################################################
export isLoginShell=1
if shopt -q login_shell; then
    export isLoginShell=0
else
    export isLoginShell=1
fi

# #############################################################################
# git branch function
# #############################################################################
function parse_git_branch() {
    # dont use porcelain command git branch
    # /usr/bin/git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1) /'

    # seen somewhere on stack overflow
    # /usr/bin/git symbolic-ref --short -q HEAD 2> /dev/null | sed 's/.*/ (&)/'

    # use the one suggested by Fedora in their bash-color-prompt doc
    /usr/bin/git rev-parse --abbrev-ref HEAD 2>/dev/null | sed 's/.*/ (&)/'
}
export -f parse_git_branch

# #############################################################################
# colorful prompt
# #############################################################################
colorRed="\[\e[00;31m\]"
colorGreen="\[\e[00;32m\]"
colorYellow="\[\e[00;33m\]"
colorBlue="\[\e[00;34m\]"
colorMagenta="\[\e[00;35m\]"
colorCyan="\[\e[00;36m\]"
colorWhite="\[\e[00;37m\]"
colorReset="\[\e[00m\]"

if [ $EUID -eq 0 ]; then
    # PS1 for root users
    export PS1="${colorMagenta}\u@\h${colorReset} ${colorYellow}\W${colorReset}${colorCyan}"
    export PS1="${PS1}"'$( parse_git_branch )'
    export PS1="${PS1}${colorReset}# "
else
    # PS1 for non-root users
    export PS1="${colorCyan}\u@\h${colorReset} ${colorYellow}\W${colorReset}${colorMagenta}"
    export PS1="${PS1}"'$( parse_git_branch )'
    export PS1="${PS1}${colorReset}$ "
fi

# #############################################################################
# shorter prompt - useful for split terminals
# #############################################################################
function shorterPrompt() {
    export PS1="${colorYellow}\W${colorReset}> "
}
export -f shorterPrompt

# #############################################################################
# clear function when terminal doesn't support it
# #############################################################################
function cls() {
    printf "%.0s\n" {1..50}
    printf '\033[3J' && clear
}
export -f cls

# #############################################################################
# print separator till the end
# #############################################################################
function printSeparator() {
    terminal_width=$(tput cols)
    printf "%.0s-" $(seq 1 ${terminal_width})
    printf "\n"
}
export -f printSeparator

# #############################################################################
# remove package without dependencies
# #############################################################################
function removeOnly() {
    if [ "${isRhel}" -eq 0 ]; then
        sudo rpm --erase --nodeps ${@}
    else
        sudo dpkg --remove --force-depends ${@}
    fi
}
export -f removeOnly

# #############################################################################
# whatProvides
# #############################################################################
function whatProvides() {
    local binpath
    binpath=$(command -v -- "$1")

    if [[ -z "$binpath" ]]; then
        echo "'$1' not found in PATH."
        return 1
    fi

    echo -n "rpm -q --file        : "
    rpm --query --file "$binpath"

    echo -n "rpm -q --whatprovides: "
    rpm --query --whatprovides "$binpath"
}
export -f whatProvides

# #############################################################################
# extractRPM
# #############################################################################
function extractRPM() {
    local rpmFile="$1"
    rpm2archive "$rpmFile"
    local base=$(basename "$rpmFile" .rpm)
    mv "$rpmFile.tgz" "$base.tar.gz"
}
export -f extractRPM

# #############################################################################
# path
# #############################################################################
function addToPath() {
    if [ -d "${1}" ] && [[ ":${PATH}:" != *":${1}:"* ]]; then
        export PATH="${1}:${PATH}"
    fi
}
# addToPath "/opt/apache-maven-3.6.3/bin"
# addToPath "/opt/node-v16.20.2-linux-x64/bin"
# addToPath "/opt/go/bin"

# #############################################################################
# env variables
# #############################################################################
export JAVA_HOME=$(readlink -f $(command -v -- java) 2>/dev/null | sed "s:/bin/java::")

if command -v -- podman &>/dev/null; then
    # source - https://quarkus.io/guides/podman
    export DOCKER_HOST=unix:///run/user/${UID}/podman/podman.sock
    # export DOCKER_HOST=unix://${XDG_RUNTIME_DIR}/podman/podman.sock
    # export DOCKER_HOST=unix://$(podman info --format '{{.Host.RemoteSocket.Path}}')
    export TESTCONTAINERS_RYUK_DISABLED=true
fi

# #############################################################################
# alias
# #############################################################################
alias vi='vim'
alias ll='ls -lF'
alias cp='cp --preserve'
alias activate='source ${HOME}/.venv/PY-ENV/bin/activate'
alias python='python3'
alias findjava='find . -type f -name "*java"'
# refer https://github.com/zbhavyai/containers/tree/main/texlive
alias latex='podman container run --privileged --rm --volume "${PWD}:/data" localhost/latex'
alias commitCount='git rev-list --count HEAD'
alias neofetch='fastfetch'

if [ "${isRhel}" -ne 0 ]; then
    alias alternatives='sudo update-alternatives'
fi

if command -v -- flatpak &>/dev/null && [ -n "$(flatpak list --app --columns=application | grep com.visualstudio.code)" ]; then
    alias code='flatpak run --branch=stable --arch=x86_64 --command=code --file-forwarding com.visualstudio.code'
fi

# #############################################################################
# clean journalctl logs
# #############################################################################
function cleanJournalLogs() {
    sudo journalctl --rotate
    sudo journalctl --vacuum-time=1s
}
export -f cleanJournalLogs

# #############################################################################
# control monitor brightness
# #############################################################################
function brightness() {
    sudo ddcutil setvcp 10 "$1" 2>/dev/null || {
        echo "Failed to set brightness."
        return 1
    }
}
export -f brightness

# #############################################################################
# miscellaneous
# #############################################################################
function fixJetbrainsMarkdownPreview() {
    # source - https://stackoverflow.com/a/79662857/16018083
    rm -f ${HOME}/.config/jetbrains/intellij-idea/system/jcef_cache/Singleton*
    rm -f ${HOME}/.config/jetbrains/pycharm/system/jcef_cache/Singleton*
    rm -f ${HOME}/.config/jetbrains/webstorm/system/jcef_cache/Singleton*
}
export -f fixJetbrainsMarkdownPreview

# #############################################################################
# source server specific bashrc
# #############################################################################
if [ -f "${HOME}/.bashrc-server" ]; then
    . "${HOME}/.bashrc-server"
fi
