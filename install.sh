#!/bin/bash
set -euo pipefail

INSTALL_DIR="${1:-"$HOME"/.git-helpers}"

if [ ! -d "$INSTALL_DIR" ]; then
    mkdir -p "$INSTALL_DIR"
    git clone --recurse-submodules https://github.com/haoadoreorange/git-helpers "$INSTALL_DIR"
    echo "Download git-helpers to $INSTALL_DIR successfully"
fi

for file in "$INSTALL_DIR"/hooks/*; do
    if [ -f "$INSTALL_DIR"/hooks/"$file" ]; then
        sudo ln -s "$INSTALL_DIR"/hooks/"$file" /usr/share/git-core/templates/hooks/
        echo "Softlink git hook $file to /usr/share/git-core/templates/hooks/ successfully"
    fi
done

echo "git-helpers hooks installed successfully"
