# vi-mode
set -o vi

# color man pages
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
alias bfg="java -jar $HOME/bin/bfg.jar"

# ssh动态隧道转发
# http://codelife.me/blog/2012/12/09/three-types-of-ssh-turneling/
# -f Fork into background after authentication.
# 后台认证用户/密码，通常和-N连用，不用登录到远程主机。
# -D port
# 指定一个本地机器 “动态的’’ 应用程序端口转发. 工作原理是这样的, 本地机器上分配了一个 socket 侦听 port 端口, 一旦这个端口上有了连接, 该连接就经过安全通道转发出去, 根据应用程序的协议可以判断出远程主机将和哪里连接. 目前支持 SOCKS4 协议, 将充当 SOCKS4 服务器. 只有 root 才能转发特权端口. 可以在配置文件中指定动态端口的转发.
# -C Enable compression.
# 压缩数据传输。
# -N Do not execute a shell or command.
# 不执行脚本或命令，通常与-f连用。
# -g Allow remote hosts to connect to forwarded ports.
# 在-L/-R/-D参数中，允许远程主机连接到建立的转发的端口，如果不加这个参数，只允许本地主机建立连接。注：这个参数我在实践中似乎始终不起作用。
alias sshp="ssh -qTfnN -D 7070 aws"
alias p8="find -iname '*.py' | xargs autopep8 -i"
#alias p8='git status -s "*.py" |awk {"print $2"} |xargs autopep8 -i'
alias sshes="ssh -fNL 9200:localhost:9200 tcloud"
alias sshdashes="ssh -fNL 9200:localhost:9200 dash"
alias bfg="java -jar $HOME/bin/bfg.jar"

HISTSIZE=10000
HISTFILESIZE=20000

# Automatically activate Git projects' virtual environments based on the
# directory name of the project. Virtual environment name can be overridden
# by placing a .venv file in the project root with a virtualenv name in it

[[ -s /usr/local/bin/virtualenvwrapper.sh ]] && source /usr/local/bin/virtualenvwrapper.sh


# 设置GITHUB用户信息
GITHUB_USERNAME="crazygit"
GITHUB_EMAIL="lianglin999@gmail.com"

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
        # 为github仓库设置独立的用户名和密码，以便和工作邮箱分开
        if $(git remote -v|grep -q "git@github.com");then
            username=$(git config user.name)
            email=$(git config user.email)
            if [ x"$username" != x"$GITHUB_USERNAME" ];then
                git config user.name $GITHUB_USERNAME
            fi
            if [ x"$email" != x"$GITHUB_EMAIL" ];then
                git config user.email $GITHUB_EMAIL
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
ANDROID_SDK_HOME="$HOME/bin/adt-bundle-linux-x86_64-20140702/sdk"
ANDROID_TOOLS_DIR="$ANDROID_SDK_HOME/tools"
ANDROID_PLATFORM_TOOLS_DIR="$ANDROID_SDK_HOME/platform-tools"
ANDROID_BUILD_TOOLS_DIR="$ANDROID_SDK_HOME/build-tools/android-4.4W"
ANT_HOME="$HOME/bin/apache-ant-1.9.2"
MAVEN_HOME="$HOME/bin/apache-maven-3.2.3"
JAVA_HOME="/usr/lib/jvm/java-7-oracle"

export ANT_HOME=$ANT_HOME
export JAVA_HOME=$JAVA_HOME
export PATH=$PATH:"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:~/bin"
export PATH=${PATH}:${ANT_HOME}/bin:${MAVEN_HOME}/bin
export PATH=$PATH:$ANDROID_SDK_HOME
export PATH=$PATH:$ANDROID_TOOLS_DIR
export PATH=$PATH:$ANDROID_PLATFORM_TOOLS_DIR
export PATH=$PATH:$ANDROID_BUILD_TOOLS_DIR

# Grep color
export GREP_COLOR='01;07;31'
