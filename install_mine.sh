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
        echo "Download vcprompt..."
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

SOURCE_STR='[[ -s $HOME/.bash_profile ]] && source $HOME/.bash_profile'

grep -q "$SOURCE_STR" $HOME/.bashrc || echo '[[ -s $HOME/.bash_profile ]] && source $HOME/.bash_profile' >> $HOME/.bashrc


# Install dircolors-solarized
test -w $HOME/.dircolors &&
      cp $HOME/.dircolors $HOME/.dircolors.bak &&
        echo "Your original $HOME/.dircolors has been backed up to $HOME/.dircolors.bak"

DIRCOLORS_SOLARIZED_DIR="$HOME/.dircolors-solarized"
if [ ! -d $DIRCOLORS_SOLARIZED_DIR ];then
    echo "Download dircolors-solarized..."
    git clone git://github.com/seebi/dircolors-solarized.git $DIRCOLORS_SOLARIZED_DIR ||
        echo "Download dircolors-solarized Failed"
fi

test -d $DIRCOLORS_SOLARIZED_DIR &&
    cp -f $DIRCOLORS_SOLARIZED_DIR/dircolors.256dark $HOME/.dircolors &&
        echo "Copied the $DIRCOLORS_SOLARIZED_DIR/dircolors.256dark to $HOME/.dircolors" ||
            echo "Install dircolors-solarized Failed"

# Install gnome-terminal-colors-solarized
GNOME_TERMINAL_COLORS_SOLARIZED_DIR="$HOME/.gnome-terminal-colors-solarized"
if [ ! -d $GNOME_TERMINAL_COLORS_SOLARIZED_DIR ];then
    echo "Download gnome-terminal-colors-solarized..."
    git clone git://github.com/sigurdga/gnome-terminal-colors-solarized.git $GNOME_TERMINAL_COLORS_SOLARIZED_DIR ||
        echo "Download gnome-terminal-colors-solarized Failed"
fi

test -d $GNOME_TERMINAL_COLORS_SOLARIZED_DIR &&
    echo "Active gnome-terminal-colors-solarized..." &&
        $GNOME_TERMINAL_COLORS_SOLARIZED_DIR/set_dark.sh ||
            echo "Active gnome-terminal-colors-solarized Failed"
