#!/bin/bash

bashrc_exists=0
zshrc_exists=0

bashrc_installed=0
zshrc_installed=0

bashrc_file="$HOME/.bashrc"
zshrc_file="$HOME/.zshrc"

if [[ ! -f $bashrc_file  ]]; then
    echo "Can not find .bashrc"
else
    echo "Found .bashrc"
    bashrc_exists=1
fi

if [[ ! -f $zshrc_file  ]]; then
    echo "Can not find .zshrc"
else
    echo "Found .zshrc"
    zshrc_exists=1
fi

echo $bashrc_exists
echo $zshrc_exists

if [[ $bashrc_exists == 0 && $zshrc_exists == 0 ]]; then
    echo "Abort install, can not find either of bashrc, zshrc"
    exit 1
fi

if grep -Fq "__bm_main" $bashrc_file 
then
    echo "Already installed in .bashrc"
    bashrc_installed=1
fi

if grep -Fq "__bm_main" $zshrc_file
then
    echo "Already installed in .zshrc"
    zshrc_installed=1
fi

if [[ $bashrc_installed == 1 && $zshrc_installed == 1 ]]; then
    echo "Already installed!, try run uninstall.sh first then run install.sh"
    exit 1
fi

# get this file path (install.sh)
file_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

_bm_main="s"
_bm_cd="sd"

read -p "Set 's' and 'sd' for default commands? " -n 1 -r

if [[ $REPLY =~ ^[Nn]$ ]]; then
    printf '\n\n'
    read -r -p "Set alias for lauching the script: " _bm_main
    read -r -p "Set alias for cd with history: " _bm_cd
    printf '\n'
else
    printf '\n'
fi

echo "Set default commands to '$_bm_main' and '$_bm_cd'"

bashrc_success=0
zshrc_success=0

if [[ $bashrc_exists == 1 && $bashrc_installed == 0 ]]; then
    echo "# dir-bookmark" >> $bashrc_file
    echo "source '$file_path/main.sh'" >> $bashrc_file
    echo "alias $_bm_main=__bm_main" >> $bashrc_file
    echo "alias $_bm_cd='__bm_main cd'" >> $bashrc_file
    bashrc_success=1
fi

if [[ $zshrc_exists == 1 && $zshrc_installed == 0 ]]; then
    echo "# dir-bookmark" >> $zshrc_file
    echo "source '$file_path/main.sh'" >> $zshrc_file
    echo "alias $_bm_main=__bm_main" >> $zshrc_file
    echo "alias $_bm_cd='__bm_main cd'" >> $zshrc_file
    zshrc_success=1
fi

source "$file_path/main.sh"
alias $_bm_main=__bm_main
alias $_bm_cd='__bm_main cd'

# TODO: progressbar

if [[ $bashrc_success == 1 || $zshrc_success == 1 ]]; then
    echo "Successfully installed!"
fi
