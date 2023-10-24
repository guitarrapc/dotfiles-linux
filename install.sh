#!/bin/bash
set -eo pipefail

# this symlinks all the dotfiles (and .vim/) to ~/
# it also symlinks ~/bin for easy updating

# this is safe to run multiple times and will prompt you about anything unclear


# this is a messy edit of alrra's nice work here:
#   https://raw.githubusercontent.com/alrra/dotfiles/master/os/create_symbolic_links.sh
#   it should and needs to be improved to be less of a hack.



# jump down to line ~157 for the start.

while [ $# -gt 0 ]; do
    case $1 in
        --force) _FORCE=$2; shift 2; ;; # input y or n
        *) shift ;;
    esac
done

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
    if [[ "${_FORCE:=}" != "" ]]; then
        print_question "$1 (--force detected, skip prompt.)\n"
        REPLY=$_FORCE
        return
    fi
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

    if [[ "$OS_NAME" == "Darwin" ]]; then
        os="osx"
    elif [[ "$OS_NAME" == "Linux" ]] && [[ -e "/etc/lsb-release" ]]; then
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
    if [[ -n "$1" ]]; then
        if [[ -e "$1" ]]; then
            if [[ ! -d "$1" ]]; then
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
    if [[ "$1" == "0" ]]; then
        print_success "$2"
    else
        print_error "$2"
        exit $1
    fi
}

print_success() {
    # Print output in green
    printf "\e[0;32m  [✔] $1\e[0m\n"
}

#
# actual symlink stuff
#

# this script's directory
SCRIPT_DIR=$(cd $(dirname $0); pwd)

# finds all .dotfiles in this folder
declare -a FILES_TO_SYMLINK=$(cd "$SCRIPT_DIR"; find "." -maxdepth 1 -type f -name ".*" -not -name .DS_Store -not -name .git -not -name .gitignore -not -name .gitattributes -not -name .bash_history -not -name .editorconfig | sed -e 's|//|/|' | sed -e 's|./.|.|')
# declare other folders
OTHERS="HOME ROOT"

main() {

    # dotfiles
    echo "${FILES_TO_SYMLINK[@]}" | while read -r i ; do

        if [[ "$i" == "" ]]; then
          continue
        fi

        sourceFile="$(pwd)/$i"
        targetFile="$HOME/$(printf "%s" "$i" | sed "s/.*\/\(.*\)/\1/g")"

        # create target file's parent directory if not exists.
        dir=$(dirname "${targetFile}")
        if [[ ! -d "${dir}" ]]; then
            mkdir -p "${dir}"
        fi

        if [[ -e "$targetFile" ]]; then
            if [[ "$(readlink "$targetFile")" != "$sourceFile" ]]; then

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

    for current in ${OTHERS}; do
        # finds all .dotfiles in this folder
        declare -a TREE_OF_SYMLINK=$(cd "$SCRIPT_DIR"; find "${current}" -mindepth 1 -maxdepth 1 -type d -name "*")

        if [[ "${TREE_OF_SYMLINK}" == "" ]]; then
          continue
        fi

        # branch for HOME and ROOT
        if [[ "${current}" == "HOME" ]]; then
            target_file_root="$HOME/"
            sudo_exec=
        elif [[ "${current}" == "ROOT" ]]; then
            target_file_root="/"
            sudo_exec=sudo
        fi

        echo "${TREE_OF_SYMLINK[@]}" | while read -r i ; do

            dirs=$(find "$i" -type d)
            ifs_by_line
            for dir in ${dirs}; do
                ifs_revert
                targetDir="$HOME/$(printf "%s" "$dir" | sed -e "s|\./||g" | sed -e "s|${current}/||g")"
                if [[ ! -d "${target_file_root}${targetDir}" ]]; then
                    $sudo_exec mkdir -p "${target_file_root}${targetDir}"
                fi
            done

            files=$(find "$i" -type f)
            ifs_by_line
            for file in ${files}; do
                ifs_revert

                sourceFile="$(pwd)/$(printf "%s" "$file" | sed "s|\./||g")"
                targetFile="${target_file_root}$(printf "%s" "$file" | sed "s|\./||g" | sed "s|${current}/||g")"

                # create target file's parent directory if not exists.
                dir=$(dirname "${targetFile}")
                if [[ ! -d "${dir}" ]]; then
                    $sudo_exec mkdir -p "${dir}"
                fi

                if [[ -e "$targetFile" ]]; then
                    if [[ "$(readlink "$targetFile")" != "$sourceFile" ]]; then

                        ask_for_confirmation "'$targetFile' already exists, do you want to overwrite it?"
                        if answer_is_yes; then
                            $sudo_exec rm -rf "$targetFile"
                            $sudo_exec ln -fs "${sourceFile}" "${targetFile}" &> /dev/null
                            execute_result $? "$targetFile → $sourceFile"
                        else
                            print_error "$targetFile → $sourceFile"
                        fi

                    else
                        print_success "$targetFile → $sourceFile"
                    fi
                else
                    $sudo_exec ln -fs "${sourceFile}" "${targetFile}" &> /dev/null
                    execute_result $? "$targetFile → $sourceFile"
                fi
            done
        done
    done

}

main
