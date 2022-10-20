#!/bin/bash

bashrc_exists=0
zshrc_exists=0

bashrc_installed=0
zshrc_installed=0

bashrc_success=0
zshrc_success=0

bashrc_file="$HOME/.bashrc"
zshrc_file="$HOME/.zshrc"

# get this file path (uninstall.sh)
file_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

function uninstall_from_rc {
    # get individual installed line numbers
    comments_line=$(grep -n -F "# dir-bookmark" "$1" | cut -d':' -f1)
    source_line=$(grep -n -F $file_path "$1" | cut -d':' -f1)
    alias_lines=$(grep -n -F "__bm_main" "$1" | cut -d':' -f1)

    # concat all the numbers with new lines and reverse sort it 
    # otherwise while deleteing the lines from low to high, line number chages for high values 
    # to prevent this sort then revese the line numbers, it will fix the issue
    installed_lines=$(printf "$comments_line""\n""$source_line""\n""$alias_lines" | sort -r)

    # loop though all the line numbers and delete the line
    for line_no in $installed_lines; do
        sed -i "$line_no""d" "$1"
    done

    echo "Uninstalled successfully from $1"
}

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

if [[ $bashrc_exists == 0 && $zshrc_exists == 0 ]]; then
    echo "Abort uninstall, can not find either of bashrc, zshrc"
    exit 1
fi

if grep -Fq "__bm_main" $bashrc_file 
then
    echo "Found installed in .bashrc"
    bashrc_installed=1
fi

if grep -Fq "__bm_main" $zshrc_file
then
    echo "Found installed in .zshrc"
    zshrc_installed=1
fi

if [[ $bashrc_installed == 0 && $zshrc_installed == 0 ]]; then
    echo "Not installed in this system, try to install first by running install.sh!"
    exit 1
fi

if [[ $bashrc_installed == 1 ]]; then
    uninstall_from_rc $bashrc_file
fi

if [[ $zshrc_installed == 1 ]]; then
    uninstall_from_rc $zshrc_file
fi
