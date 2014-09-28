# vi-mode
set -o vi

#color man pages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# aliases
alias sudo="sudo -E"
alias clear='clear;reset'
alias sshp="ssh -qTfnN -D 7070 aws"


HISTSIZE=10000
HISTFILESIZE=20000

# Automatically activate Git projects' virtual environments based on the
# directory name of the project. Virtual environment name can be overridden
# by placing a .venv file in the project root with a virtualenv name in it

[[ -s /usr/local/bin/virtualenvwrapper.sh ]] && source /usr/local/bin/virtualenvwrapper.sh

function workon_cwd {
    # Check that this is a Git repo
    GIT_DIR=`git rev-parse --git-dir 2> /dev/null`
    if [ $? == 0 ]; then
        # Find the repo root and check for virtualenv name override
        GIT_DIR=`\cd $GIT_DIR; pwd`
        PROJECT_ROOT=`dirname "$GIT_DIR"`
        ENV_NAME=`basename "$PROJECT_ROOT"`
        if [ -f "$PROJECT_ROOT/.venv" ]; then
            ENV_NAME=`cat "$PROJECT_ROOT/.venv"`
        fi
        # Activate the environment only if it is not already active
        if [ "$VIRTUAL_ENV" != "$WORKON_HOME/$ENV_NAME" ]; then
            if [ -e "$WORKON_HOME/$ENV_NAME/bin/activate" ]; then
                workon "$ENV_NAME" && export CD_VIRTUAL_ENV="$ENV_NAME"
            fi
        fi
    elif [ $CD_VIRTUAL_ENV ]; then
        # We've just left the repo, deactivate the environment
        # Note: this only happens if the virtualenv was activated automatically
        deactivate && unset CD_VIRTUAL_ENV
    fi
}

# New cd function that does the virtualenv magic
function venv_cd {
    cd "$@" && workon_cwd
}

alias cd="venv_cd"
# init for create new terminal tab
workon_cwd

# set for local path
ANDROID_SDK_HOME="$HOME/bin/adt-bundle-linux/sdk"
ANDROID_TOOLS_DIR="$ANDROID_SDK_HOME/tools"
ANDROID_PLATFORM_TOOLS_DIR="$ANDROID_SDK_HOME/platform-tools"
ANDROID_BUILD_TOOLS_DIR="$ANDROID_SDK_HOME/build-tools/android-4.4"
ANT_HOME="$HOME/bin/apache-ant-1.9.2"
JAVA_HOME="/usr/lib/jvm/java-7-oracle"

export ANT_HOME=$ANT_HOME
export JAVA_HOME=$JAVA_HOME
export PATH=$PATH:"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:~/bin"
export PATH=${PATH}:${ANT_HOME}/bin
export PATH=$PATH:$ANDROID_SDK_HOME
export PATH=$PATH:$ANDROID_TOOLS_DIR
export PATH=$PATH:$ANDROID_PLATFORM_TOOLS_DIR
export PATH=$PATH:$ANDROID_BUILD_TOOLS_DIR

# Grep color
export GREP_COLOR='01;07;31'
