#!/bin/bash
# Based on:  https://github.com/rexim/dotfiles/blob/master/deploy.sh
# Original author: rexim

set -e

SCRIPT_DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

symlinkFile() {
    local repo_path="$1"
    local dest_field="$2"
    local link_name="$3"
    local filename="$SCRIPT_DIR/$repo_path"
    local destination

    # Third field is the directory under $HOME (e.g. ".config"), or "-" to place
    # the symlink directly in $HOME (fourth field must be the final name, e.g. ".zshrc").
    # If the third field is empty, the default link path under $HOME is ${link_name:-$repo_path}.
    if [[ "$dest_field" == "-" ]]; then
        if [[ -z "$link_name" ]]; then
            echo "[ERROR] $repo_path: destination \"-\" requires a target name (4th column)."
            exit 1
        fi
        destination="$HOME/$link_name"
    elif [[ -n "$dest_field" ]]; then
        destination="$HOME/$dest_field/${link_name:-$repo_path}"
    else
        destination="$HOME/${link_name:-$repo_path}"
    fi

    mkdir -p "$(dirname "$destination")"

    if [ -L "$destination" ]; then
        echo "[WARNING] $filename already symlinked"
        return
    fi

    if [ -e "$destination" ]; then
        echo "[ERROR] $destination exists but it's not a symlink. Please fix that manually"
        exit 1
    fi

    ln -s "$filename" "$destination"
    echo "[OK] $filename -> $destination"
}

deployManifest() {
    for row in $(cat $SCRIPT_DIR/$1); do
        if [[ "$row" =~ ^#.* ]]; then
            continue
        fi

        filename=$(echo $row | cut -d \| -f 1)
        operation=$(echo $row | cut -d \| -f 2)
        destination=$(echo $row | cut -d \| -f 3)
        target=$(echo $row | cut -d \| -f 4)

        case $operation in
            symlink)
                symlinkFile $filename $destination $target
                ;;

            *)
                echo "[WARNING] Unknown operation $operation. Skipping..."
                ;;
        esac
    done
}

if [ -z "$@" ]; then
    echo "Usage: $0 <MANIFEST>"
    echo "ERROR: no MANIFEST file is provided"
    exit 1
fi

deployManifest $1
