#!/bin/bash
set -euo pipefail

GREEN='\033[0;32m'
NC='\033[0m' # No Color
INSTALL_DIR="${1:-"$HOME"/.git-helpers}"

if [ ! -d "$INSTALL_DIR" ]; then
    mkdir -p "$INSTALL_DIR"
    git clone --recurse-submodules https://github.com/haoadoreorange/git-helpers "$INSTALL_DIR"
    echo -e "${GREEN}Download git-helpers to $INSTALL_DIR successfully${NC}"
else
    (
        cd "$INSTALL_DIR"
        git pull
    )
fi

set +e
for file in "$INSTALL_DIR"/hooks/*; do
    if [ -f "$file" ]; then
        chmod +x "$(realpath "$file")"
        sudo ln -s "$file" /usr/share/git-core/templates/hooks/ &&
            echo -e "${GREEN}Softlink git hook $file to /usr/share/git-core/templates/hooks/ successfully${NC}"
    fi
done

[ "$?" == "0" ] && echo -e "${GREEN}git-helpers hooks installed succesfully${NC}"
