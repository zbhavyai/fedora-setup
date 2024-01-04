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


# #################################################
# determine type of distro
# #################################################
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
# git branch function
# #############################################################################

parse_git_branch() {
    # dont use porcelain command git branch
    # git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'
    git symbolic-ref --short -q HEAD 2> /dev/null | sed 's/.*/(&)/'
}

export -f parse_git_branch

    colorRed="\[\e[00;31m\]"
  colorGreen="\[\e[00;32m\]"
 colorYellow="\[\e[00;33m\]"
   colorBlue="\[\e[00;34m\]"
colorMagenta="\[\e[00;35m\]"
   colorCyan="\[\e[00;36m\]"
  colorWhite="\[\e[00;37m\]"
  colorReset="\[\e[00m\]"

export PS1="${debian_chroot:+($debian_chroot)}${colorCyan}\u@\h${colorReset} ${colorYellow}\W${colorReset} ${colorMagenta}"
export PS1="${PS1}"'$( parse_git_branch )'
export PS1="${PS1}${colorReset}$ "
export PS1_BKP="${PS1}"


# #############################################################################
# rename tab function
# #############################################################################

# does not work with all types of terminals

# renameTab() {
#     # printf "\e]2;${1}\a"
#     echo -en "\033]0;$@\007"
#
#     # if rename is called, disable title change on PS1
#     PS1="${PS1_BKP}"
# }

# export -f renameTab


# #############################################################################
# default tab title
# #############################################################################

# # If this is an xterm set the title to dir
# case "$TERM" in
# xterm*|rxvt*)
#     PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\w\a\]$PS1"
#     ;;
# *)
#     ;;
# esac


# #############################################################################
# using pyenv
# #############################################################################

# export PYENV_ROOT="$HOME/.pyenv"
# command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"
# alias activate='pyenv shell PY-ENV'
# alias deactivate='pyenv shell system'

