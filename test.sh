#!/usr/bin/env bash

set -o nounset

DIR_TESTS=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

source "$DIR_TESTS/assert.sh"
source "$DIR_TESTS/main.sh"

log_header "Test assert : main.sh"

test_assert_eq() {
    log_header "Test :: assert_eq"

    assert_eq "Hello" "Hello"
    if [ "$?" == 0 ]; then
        log_success "assert_eq returns 0 if two words are equal"
    else
        log_failure "assert_eq should return 0"
        exit 1
    fi

    assert_eq "Hello" "World"
    if [ "$?" == 1 ]; then
        log_success "assert_eq returns 1 if two words are not equal"
    else
        log_failure "assert_eq should return 1"
    fi
}

test_help() {
    log_header "Test :: Help"

    local result=$(__bm_show_help test)

    assert_contain "$result" "bookmark"
    if [ "$?" == 0 ]; then
        log_success "help contains 'bookmark'"
    else
        log_failure "help does not contains 'bookmark'"
        exit 1
    fi
}

test_main() {
    log_header "Test :: __bm_main"

    local DB_DIR="$HOME/.local/share/dir-bookmark"
    local BOOKMARK_FILE="$DB_DIR/bookmark_list.txt"
    local HISTORY_FILE="$DB_DIR/history_list.txt"

    # if  bookmark file is exists remove it
    if [[ -f "$BOOKMARK_FILE" ]]; then
        rm "$BOOKMARK_FILE"
    fi

    # if  history file is exists remove it
    if [[ -f "$HISTORY_FILE" ]]; then
        rm "$HISTORY_FILE"
    fi

    local history_exists=false
    local bookmark_exists=false
    local result=$(__bm_main foo)

    if [[ -f "$BOOKMARK_FILE" ]]; then
        bookmark_exists=true
    fi

    if [[ -f "$BOOKMARK_FILE" ]]; then
        history_exists=true
    fi

    assert_contain "$result" "default"
    if [ "$?" == 0 ]; then
        log_success "__bm_main echo default if wrong args provided"
    else
        log_failure "__bm_main does not echo default if wrong args provided"
        exit 1
    fi

    assert_true $bookmark_exists
    if [ "$?" == 0 ]; then
        log_success "__bm_main creates bookmark db file"
    else
        log_failure "__bm_main does not creates bookmark db file"
        exit 1
    fi

    assert_true $history_exists
    if [ "$?" == 0 ]; then
        log_success "__bm_main creates history db file"
    else
        log_failure "__bm_main does not creates history db file"
        exit 1
    fi
}

# test calls

# test_help
test_main
