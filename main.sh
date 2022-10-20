#!/bin/bash

function __bm_go_to_selected_dir {
    selected=$(tac "$1" | fzf --info=inline --height=50% --layout=reverse --preview='ls -C -p --color=always {}' --preview-window=down,30%)
    if [[ $selected != "" ]]; then
        cd "$selected" || return 1
    fi
}

function __bm_remove_entry {
    selected=$(grep -n '' "$1" | tac | fzf --info=inline --height=50% --layout=reverse)
    if [[ $selected != "" ]]; then
        echo "Delete?: $selected"
        select yn in "Yes" "No"; do
            case $yn in
                Yes )
                    line_no=$(echo $selected | cut -d':' -f1)
                    sed -i "$line_no""d" "$1"
                    echo "Deleted: $selected"
                    return ;;
                No )
                    echo "Cancelled."
                    return ;;
            esac
        done
    else
        echo "Cancelled."
    fi
}

function __bm_unique_list {
    # Remove duplicated from list, order of operation: delete old keep new
    clean_list=$(tac $1 | awk '!a[$0]++' | tac)
    echo $clean_list > $1
}

function __bm_add_entry {
    # add new valid directory to bookmark
    if [[ ! -d "$2" ]]; then
        echo "Not a valid directory!"
        return 1
    fi
    echo $2 >> $1
    __bm_unique_list $1
}

function __bm_show_help {
    echo "bm 0.01.0"
    echo "A directory bookmark tool and cd tool with some other cool stuff"
    echo ""

    echo "Script usage:  $1 [Flags/Commands] [Options] [Path] ..."
    echo ""

    echo "Flags/Commands:"
    echo "      .                                                 Add current path to bookmark: '$1 .' "
    echo "      a , -a , add, -add, --add-bookmark <path>         Add path to bookmark works with pipes too: 'pwd | $1 add'"
    echo "      b , -b , --bookmark                               Select bookmark and cd to it, run without any flags/commads works as well: '$1'"
    echo "      l , -l , --list-history                           Select history from and cd to it"
    echo "      e , -e , --edit, --edit-bookmark                  Edit bookmark in vim"
    echo "      eh, -eh, --edit-bookmark                          Edit history in vim"
    echo "      r , -r , --remove, --remove-bookmark              Remove an entry from bookmark"
    echo "      rh, -rh, --remove-bookmark                        Remove an entry from history"
    echo "      cd <path>                                         Same as cd except it will add visited path to history list and support pipe: '$HOME | $1 cd -i'"
    echo "      h , -h , --help                                   Show help"
}

function __bm_main {
    # storage dir and file
    local DB_DIR="$HOME/.local/share/dir-bookmark"
    local BOOKMARK_FILE="$DB_DIR/bookmark_list.txt"
    local HISTORY_FILE="$DB_DIR/history_list.txt"
    local me=$(basename "$0")



    # if  db directory is not found then create one
    if [[ ! -d "$DB_DIR" ]]; then
        mkdir -p "$DB_DIR"
    fi

    # if  bookmark file is not found then create one
    if [[ ! -f "$BOOKMARK_FILE" ]]; then
        touch "$BOOKMARK_FILE"
    fi

    # if  history file is not found then create one
    if [[ ! -f "$HISTORY_FILE" ]]; then
        touch "$HISTORY_FILE"
    fi

    case $1 in
        cd) # cd and store history
            if [[ $2 == "i" || $2 == "-i" ]]; then
                # work with pipe
                #TODO
                return 0
            fi

            if [[ $2 == "--help" ]]; then
                # show help
                echo "bm 0.01.0"
                echo "A cd tool with some other cool stuff, use just like cd except it will also add visited path to an history list"
                echo ""

                echo "Script usage:  $me cd [Flags/Commands] [Options] [Path] ..."
                echo ""

                echo "Flags/Commands:"
                echo "      i , -i                     Send path with pipe: '$HOME | $me cd -i'"
                echo "      --help                     Show help"
                return 0
            fi

            if [[ $2 != "" ]]; then
                cd $2 && pwd >> $HISTORY_FILE
                __bm_unique_list $HISTORY_FILE
            fi
            ;;
        .)  # add current directory to bookmark
            pwd >> "$BOOKMARK_FILE"
            __bm_unique_list $BOOKMARK_FILE
            ;;
        a|-a|add|-add|--add-bookmark)  # add bookmark by passeing argument or pipe
            if [[ $2 != "" ]]; then
                # if path coming from an argumet eg: bookmark_dir add '/usr/bin/'
                if [[ $2 == '.' ]]; then
                    pwd >> "$BOOKMARK_FILE"
                    __bm_unique_list $BOOKMARK_FILE
                else
                    __bm_add_entry $BOOKMARK_FILE $2
                fi
            else
                # If path coming from pipe eg: pwd | bookmark_dir add
                read -r line
                __bm_add_entry $BOOKMARK_FILE $line
            fi
            ;;
        ''|b|-b|--bookmark) # select bookmark from $BOOKMARK_FILE and cd to it
            echo "Bookmarks:"
            __bm_go_to_selected_dir "$BOOKMARK_FILE"
            ;;
        l|-l|--list-history) # select history from $HISTORY_FILE and cd to it
            echo "Recent history:"
            __bm_go_to_selected_dir "$HISTORY_FILE"
            ;;
        e|-e|--edit|--edit-bookmark) # Edit $BOOKMARK_FILE file in vim
            vim "$BOOKMARK_FILE"
            ;;
        eh|-eh|--edit-history) # Edit $HISTORY_FILE file in vim
            vim "$HISTORY_FILE"
            ;;
        r|-r|--remove|--remove-bookmark) # Remove an entry from $BOOKMARK_FILE
            echo "Select a bookmark to remove <Esc> to cancel:"
            __bm_remove_entry "$BOOKMARK_FILE"
            ;;
        rh|-rh|--remove-history) # Remove an entry from $HISTORY_FILE
            echo "Select a history to remove <Esc> to cancel:"
            __bm_remove_entry "$HISTORY_FILE"
            ;;
        h|-h|--help) # show help
            __bm_show_help $me
            ;;
        *) echo default
            ;;
    esac
}
