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
    binpath=$(command -v "$1")

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
if command -v java &>/dev/null; then
    # set java home
    export JAVA_HOME=$(readlink -f $(command -v java) | sed "s:/bin/java::")
fi
if ! rpm -q docker-ce &>/dev/null && command -v docker &>/dev/null; then
    # set these when docker is not installed and docker is emulated by podman
    # podman for quarkus: https://quarkus.io/blog/quarkus-devservices-testcontainers-podman/
    export DOCKER_HOST=unix:///run/user/${UID}/podman/podman.sock
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
alias latex='podman container run --privileged --rm --volume "${PWD}:/data" --name latex latex'
alias commitCount='git rev-list --count HEAD'

if [ "${isRhel}" -ne 0 ]; then
    alias alternatives='sudo update-alternatives'
fi

if command -v flatpak &>/dev/null && [ -n "$(flatpak list --app --columns=application | grep com.visualstudio.code)" ]; then
    alias code='flatpak run --branch=stable --arch=x86_64 --command=code --file-forwarding com.visualstudio.code'
fi

# #############################################################################
# ollama bash completion https://github.com/ollama/ollama/issues/1653#issuecomment-2184527185
# #############################################################################
if command -v ollama &> /dev/null; then
    function _complete_ollama() {
        local cur prev words cword
        _init_completion -n : || return

        if [[ ${cword} -eq 1 ]]; then
            COMPREPLY=($(compgen -W "serve create show run push pull list ps cp rm help" -- "${cur}"))
        elif [[ ${cword} -eq 2 ]]; then
            case "${prev}" in
                (run|show|cp|rm|push|list)
                    WORDLIST=$((ollama list 2>/dev/null || echo "") | tail -n +2 | cut -d "	" -f 1)
                    COMPREPLY=($(compgen -W "${WORDLIST}" -- "${cur}"))
                    __ltrim_colon_completions "$cur"
                    ;;
            esac
        fi
    }
    complete -F _complete_ollama ollama
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
# source work specific bashrc
# #############################################################################
if [ -f "${HOME}/.bashrc-work" ]; then
    . "${HOME}/.bashrc-work"
fi
