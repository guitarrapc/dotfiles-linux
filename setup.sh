#!/bin/bash

# this symlinks all the dotfiles (and .vim/) to ~/
# it also symlinks ~/bin for easy updating

# this is safe to run multiple times and will prompt you about anything unclear


# this is a messy edit of alrra's nice work here:
#   https://raw.githubusercontent.com/alrra/dotfiles/master/os/create_symbolic_links.sh
#   it should and needs to be improved to be less of a hack.



# jump down to line ~140 for the start.



#
# utils !!!
#

declare -a PRE_IFS=$IFS

answer_is_yes() {
    [[ "$REPLY" =~ ^[Yy]$ ]] \
        && return 0 \
        || return 1
}

ask() {
    print_question "$1"
    read
}

ask_for_confirmation() {
    print_question "$1 (y/n) "
    read -n 1
    printf "\n"
}

ask_for_sudo() {

    # Ask for the administrator password upfront
    sudo -v

    # Update existing `sudo` time stamp until this script has finished
    # https://gist.github.com/cowboy/3118588
    while true; do
        sudo -n true
        sleep 60
        kill -0 "$$" || exit
    done &> /dev/null &

}

cmd_exists() {
    [ -x "$(command -v "$1")" ] \
        && printf 0 \
        || printf 1
}

execute() {
    $1 &> /dev/null
    print_result $? "${2:-$1}"
}

execute_result() {
    print_result $1 "${2:-$1}"
}

get_answer() {
    printf "$REPLY"
}

get_os() {

    declare -r OS_NAME="$(uname -s)"
    local os=""

    if [ "$OS_NAME" == "Darwin" ]; then
        os="osx"
    elif [ "$OS_NAME" == "Linux" ] && [ -e "/etc/lsb-release" ]; then
        os="ubuntu"
    fi

    printf "%s" "$os"

}

ifs_by_line() {
    IFS=$'\n'
}
ifs_revert() {
    IFS=$PRE_IFS
}

is_git_repository() {
    [ "$(git rev-parse &>/dev/null; printf $?)" -eq 0 ] \
        && return 0 \
        || return 1
}

mkd() {
    if [ -n "$1" ]; then
        if [ -e "$1" ]; then
            if [ ! -d "$1" ]; then
                print_error "$1 - a file with the same name already exists!"
            else
                print_success "$1"
            fi
        else
            execute "mkdir -p $1" "$1"
        fi
    fi
}

print_error() {
    # Print output in red
    printf "\e[0;31m  [✖] $1 $2\e[0m\n"
}

print_info() {
    # Print output in purple
    printf "\n\e[0;35m $1\e[0m\n\n"
}

print_question() {
    # Print output in yellow
    printf "\e[0;33m  [?] $1\e[0m"
}

print_result() {
    [ $1 -eq 0 ] \
        && print_success "$2" \
        || print_error "$2"

    [ "$3" == "true" ] && [ $1 -ne 0 ] \
        && exit
}

print_success() {
    # Print output in green
    printf "\e[0;32m  [✔] $1\e[0m\n"
}

#
# actual symlink stuff
#

# finds all .dotfiles in this folder
declare -a FILES_TO_SYMLINK=$(find . -maxdepth 1 -type f -name ".*" -not -name .DS_Store -not -name .git -not -name .gitignore -not -name .bash_history -not -name .DS_Store | sed -e 's|//|/|' | sed -e 's|./.|.|')
#FILES_TO_SYMLINK="$FILES_TO_SYMLINK .vim bin" # add in vim and the binaries

# find all directories to keep directory tree and symlink child files
declare -a DIR_TREE_OF_SYMLINK=$(find home -mindepth 1 -maxdepth 1 -type d -name "*")

# find all directories to keep directory tree and symlink child files
declare -a ROOT_DIR_TREE_OF_SYMLINK=$(find root -mindepth 1 -maxdepth 1 -type d -name "*")

main() {

    # dotfiles
    local i=""
    local sourceFile=""
    local targetFile=""
    for i in ${FILES_TO_SYMLINK[@]}; do

        sourceFile="$(pwd)/$i"
        targetFile="$HOME/$(printf "%s" "$i" | sed "s/.*\/\(.*\)/\1/g")"

        if [ -e "$targetFile" ]; then
            if [ "$(readlink "$targetFile")" != "$sourceFile" ]; then

                ask_for_confirmation "'$targetFile' already exists, do you want to overwrite it?"
                if answer_is_yes; then
                    rm -rf "$targetFile"
                    execute "ln -fs $sourceFile $targetFile" "$targetFile → $sourceFile"
                else
                    print_error "$targetFile → $sourceFile"
                fi

            else
                print_success "$targetFile → $sourceFile"
            fi
        else
            execute "ln -fs $sourceFile $targetFile" "$targetFile → $sourceFile"
        fi

    done

    # home directory
    local targetDir=""
    local d=""
    local f=""
    for i in ${DIR_TREE_OF_SYMLINK[@]}; do

        dirs=$(find $i -type d)
        ifs_by_line
        for d in ${dirs}; do
            ifs_revert
            targetDir="$HOME/$(printf "%s" "$d" | sed "s/\.\///g" | sed "s/home\///g")"
            mkdir -p "$targetDir"
        done

        files=$(find $i -type f)
        ifs_by_line
        for f in ${files}; do
            ifs_revert

            sourceFile="$(pwd)/$(printf "%s" "$f" | sed "s/\.\///g")"
            targetFile="$HOME/$(printf "%s" "$f" | sed "s/\.\///g" | sed "s/home\///g")"

            if [ -e "$targetFile" ]; then
                if [ "$(readlink "$targetFile")" != "$sourceFile" ]; then

                    ask_for_confirmation "'$targetFile' already exists, do you want to overwrite it?"
                    if answer_is_yes; then
                        rm -rf "$targetFile"
                        ln -fs "${sourceFile}" "${targetFile}" &> /dev/null
                        execute_result $? "$targetFile → $sourceFile"
                    else
                        print_error "$targetFile → $sourceFile"
                    fi

                else
                    print_success "$targetFile → $sourceFile"
                fi
            else
                ln -fs "${sourceFile}" "${targetFile}" &> /dev/null
                execute_result $? "$targetFile → $sourceFile"
            fi
        done
    done

    # root directories
    for i in ${ROOT_DIR_TREE_OF_SYMLINK[@]}; do

        dirs=$(find $i -type d)
        ifs_by_line
        for d in ${dirs}; do
            ifs_revert
            targetDir="/$(printf "%s" "$d" | sed "s/\.\///g" | sed "s/root\///g")"
            mkdir -p "$targetDir"
        done

        files=$(find $i -type f)
        ifs_by_line
        for f in ${files}; do
            ifs_revert

            sourceFile="$(pwd)/$(printf "%s" "$f" | sed "s/\.\///g")"
            targetFile="/$(printf "%s" "$f" | sed "s/\.\///g" | sed "s/root\///g")"

            if [ -e "$targetFile" ]; then
                if [ "$(readlink "$targetFile")" != "$sourceFile" ]; then

                    ask_for_confirmation "'$targetFile' already exists, do you want to overwrite it?"
                    if answer_is_yes; then
                        rm -rf "$targetFile"
                        ln -fs "${sourceFile}" "${targetFile}" &> /dev/null
                        execute_result $? "$targetFile → $sourceFile"
                    else
                        print_error "$targetFile → $sourceFile"
                    fi

                else
                    print_success "$targetFile → $sourceFile"
                fi
            else
                ln -fs "${sourceFile}" "${targetFile}" &> /dev/null
                execute_result $? "$targetFile → $sourceFile"
            fi
        done
    done
}

main
