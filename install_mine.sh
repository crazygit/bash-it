#!/usr/bin/env bash
BASH_IT="$HOME/.bash_it"

case $OSTYPE in
  darwin*)
    CONFIG_FILE=.bash_profile
    ;;
  *)
    CONFIG_FILE=.bashrc
    ;;
esac

BACKUP_FILE=$CONFIG_FILE.bak

if [ -e "$HOME/$BACKUP_FILE" ]; then
    echo -e "\033[0;33mBackup file already exists. Make sure to backup your .bashrc before running this installation.\033[0m" >&2
    while true
    do
        read -e -n 1 -r -p "Would you like to overwrite the existing backup? This will delete your existing backup file ($HOME/$BACKUP_FILE) [y/N] " RESP
        case $RESP in
        [yY])
            break
            ;;
        [nN]|"")
            echo -e "\033[91mInstallation aborted. Please come back soon!\033[m"
            exit 1
            ;;
        *)
            echo -e "\033[91mPlease choose y or n.\033[m"
            ;;
        esac
    done
fi

test -w "$HOME/$CONFIG_FILE" &&
  cp -a "$HOME/$CONFIG_FILE" "$HOME/$CONFIG_FILE.bak" &&
  echo -e "\033[0;32mYour original $CONFIG_FILE has been backed up to $CONFIG_FILE.bak\033[0m"

cp "$HOME/.bash_it/template/bash_profile.template.bash" "$HOME/$CONFIG_FILE"

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
