#!/bin/sh
set -eu

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color
INSTALL_DIR="$(realpath "${1:-$HOME/.git-helpers}")"

if [ ! -d "$INSTALL_DIR"/hooks ]; then
    printf "${GREEN}Downloading git-helpers to %s${NC}\n" "$INSTALL_DIR"
    git clone --recurse-submodules https://github.com/haoadoreorange/git-helpers "$INSTALL_DIR"
else
    printf "${GREEN}git-helpers already downloaded at %s, pulling newest commit${NC}\n" "$INSTALL_DIR"
    cd "$INSTALL_DIR"
    git pull
fi

git_hooks=/usr/share/git-core/templates/hooks
for file in "$INSTALL_DIR"/hooks/*; do
    if [ -f "$file" ]; then
        if [ ! -f "$git_hooks/$(basename "$file")" ]; then
            printf "${GREEN}Softlinking git hook '%s' to %s${NC}\n" "$(basename "$file")" "$git_hooks"
            chmod +x "$file"
            sudo ln -s "$file" "$git_hooks"/
        else
            printf "${RED}ERROR: git hook '%s' already exists in %s${NC}\n" "$(basename "$file")" "$git_hooks"
            failed=true
        fi
    fi
done

[ "${failed-}" != "true" ] && printf "${GREEN}git-helpers hooks installed succesfully${NC}\n"
