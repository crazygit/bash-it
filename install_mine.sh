#!/usr/bin/env bash

BASH_IT="$HOME/.bash_it"

test -w $HOME/.bash_profile &&
      cp $HOME/.bash_profile $HOME/.bash_profile.bak &&
        echo "Your original .bash_profile has been backed up to .bash_profile.bak"

cp $HOME/.bash_it/template/bash_profile.template.bash.mine $HOME/.bash_profile

echo "Copied the template .bash_profile into ~/.bash_profile, edit this file to customize bash-it"


# install vcprompt
if [ ! -x $HOME/bin/vcprompt ];then
    if [ -z "$(which curl)" ];then
        echo "Need install curl to install vcprompt"
        sudo apt-get install -y curl
    fi
    mkdir -p $HOME/bin &&
        curl -sL https://github.com/djl/vcprompt/raw/master/bin/vcprompt > $HOME/bin/vcprompt &&
        chmod +x $HOME/bin/vcprompt
fi

# enable aliases, plugins, completion
for type in "aliases" "plugins" "completion"
do
    for x in `cat $BASH_IT/${type}/enabled/enabled.${type}.list`
    do
        ln -sf $BASH_IT/${type}/available/$x $BASH_IT/${type}/enabled
    done
done
