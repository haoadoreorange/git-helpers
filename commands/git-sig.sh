#!/bin/sh
set -eu

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# configure git signature
git_sig() {
    name="${1:?}"
    email="${2:?}"
    # if init flag = true then add .sig file for commit hook
    if [ "${init-}" = "true" ]; then
        if [ -d .git ]; then
            echo "name='$name'" >.sig
            echo "email='$email'" >>.sig
            printf "${GREEN}Created .sig file${NC}\n"
            touch .gitignore
            while read -r line; do
                [ "$line" = ".sig" ] && matched=true && break
            done <.gitignore
            if [ "${matched-}" != "true" ]; then
                printf "\n.sig" >>.gitignore
                printf "${GREEN}Added .sig file to .gitignore${NC}\n"
            fi
        else
            printf "${RED}ERROR: Current dir is not a git repo, cannot sig init${NC}\n"
        fi
    fi
    git config --global user.name "$name"
    git config --global user.email "$email"
}

if [ "${1-}" = "--init" ]; then
    init=true
    shift
elif [ -d .git ] && [ ! -f .sig ]; then
    printf "${YELLOW}To create a .sig file in the current repo for git pre-commit hook, run with --init${NC}\n"
    printf "${YELLOW}Learn more at https://github.com/haoadoreorange/git-helpers${NC}\n"
fi

# If there is only 1 argument, then it's a profile
if [ -z "${2-}" ]; then
    profile="${1:-default}"
    printf "Configure git signature with %s profile\n" "$profile"
    sig_tmp=.sig.tmp
    # Parse profile file, inspired by https://stackoverflow.com/questions/6318809/how-do-i-grab-an-ini-value-within-a-shell-script
    sig_tmp_content="$(grep -A2 "\[$profile\]" "$HOME"/.sig.profile | grep '=' | sed 's/ *= */=/g')"
    if [ -z "$sig_tmp_content" ]; then
        printf "${RED}%s profile not found in .sig.profile${NC}\n" "$profile"
        exit 1
    fi
    echo "$sig_tmp_content" >"$sig_tmp"
    . ./"$sig_tmp"
    rm "$sig_tmp"
else
    name="$1"
    email="$2"
fi
printf ": %s <%s>\n" "${name:?}" "${email:?}"
git_sig "$name" "$email"
