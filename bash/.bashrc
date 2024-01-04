# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
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
# git branch function
# #############################################################################
parse_git_branch() {
    # dont use porcelain command git branch
    # git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'
    git symbolic-ref --short -q HEAD 2> /dev/null | sed 's/.*/(&)/'
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
    export PS1="${colorMagenta}\u@\h${colorReset} ${colorYellow}\W${colorReset} ${colorCyan}"
    export PS1="${PS1}"'$( parse_git_branch )'
    export PS1="${PS1}${colorReset}# "
else
    # PS1 for non-root users
    export PS1="${colorCyan}\u@\h${colorReset} ${colorYellow}\W${colorReset} ${colorMagenta}"
    export PS1="${PS1}"'$( parse_git_branch )'
    export PS1="${PS1}${colorReset}$ "
fi
CUSTOM_PS1="${PS1}"


# #############################################################################
# clear function when terminal doesn't support it
# #############################################################################
cls() {
    printf "%.0s\n" {1..50}
    clear
}
export -f cls


# #############################################################################
# print separator till the end
# #############################################################################
function printSeparator() {
    terminal_width=$(tput cols)
    # for ((i = 1; i <= terminal_width; i++)); do
    #     printf "$1"
    # done
	printf "%.0s-" $(seq 1 ${terminal_width})
    printf "\n"
}
export -f printSeparator


# #############################################################################
# remove package without dependencies
# #############################################################################
removeOnly() {
    if [ "${isRhel}" -eq 0 ]; then
        sudo rpm --erase --nodeps ${@}
    else
        sudo dpkg --remove --force-depends ${@}
    fi
}
export -f removeOnly


# #############################################################################
# path and alias
# #############################################################################

# alias
alias vi='vim'
alias cls='clear'
alias ll='ls -lF'
alias python='python3'
alias prettyjson='json_pp -json_opt pretty,canonical'
alias prettyjson='python3 -mjson.tool'
alias prettyjson='jq'
alias findjava='find . -type f -name "*java"'

# either use this, or use "ssh testMachine". Check ssh_config file
alias sshtestMachine='ssh root@testnet2 -p 2299'


# java
export JAVA_HOME="/etc/alternatives/java_sdk"
# for manual installation
# export JAVA_HOME="/opt/jdk-17.0.5+8"
# export PATH="${JAVA_HOME}/bin:${PATH}"

# maven
export PATH="${PATH}:/opt/apache-maven-3.8.6/bin"

# node
export PATH="${PATH}:/opt/node-v18.11.0-linux-x64/bin"

# podman (from https://quarkus.io/blog/quarkus-devservices-testcontainers-podman/)
export DOCKER_HOST=unix:///run/user/${UID}/podman/podman.sock
export TESTCONTAINERS_RYUK_DISABLED=true

# python
alias activate='source /home/zbhavyai/.venv/PY-ENV/bin/activate'


# #############################################################################
# tab renaming - doesn't work with gnome-terminal on Fedora
# #############################################################################
renameTab() {
    # printf "\e]2;${1}\a"
    echo -en "\033]0;$@\007"
	PS1="${CUSTOM_PS1}"
}
export -f renameTab


# #############################################################################
# using pyenv
# #############################################################################

# export PYENV_ROOT="$HOME/.pyenv"
# command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"
# alias activate='pyenv shell PY-ENV'
# alias deactivate='pyenv shell system'

