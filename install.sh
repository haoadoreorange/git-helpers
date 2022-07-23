#!/bin/sh
set -eu

GREEN='\033[0;32m'
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

for file in "$INSTALL_DIR"/hooks/*; do
    if [ -f "$file" ]; then
        printf "${GREEN}Softlinking git hook '%s' to /usr/share/git-core/templates/hooks/${NC}\n" "$(basename "$file")"
        chmod +x "$file"
        sudo ln -s "$file" /usr/share/git-core/templates/hooks/ || failed=true
    fi
done

[ "${failed-}" != "true" ] && printf "${GREEN}git-helpers hooks installed succesfully${NC}\n"
