#!/bin/sh
set -eu

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

[ "${1-}" = '--global' ] && global=${1} && shift
if [ ! "${global-}" ]; then
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || {
    printf '%b\n' "${RED}error: Not git repo${NC}" >&2
    exit 1
  }
fi
: ${1:?usage: $(basename "$0") [--global] <profile> or <name> <email> [<profile>]}

if [ "${2-}" ]; then
  name=${1}
  email=${2}
  if [ "${3-}" ]; then (
    SOURCE=true . "$(dirname "$(realpath "$0")")/../install.sh"
    edit -n "$HOME/.gitprofile" sed "/^\[${3}\]$/,+2d" <<EOF
[$3]
name=$name
email=$email
EOF
  ); fi
else # 1 or 0 argument -> it's a profile
  profile=${1}
  gitprofile=$(grep -F -A2 "[$profile]" "$HOME/.gitprofile" 2>/dev/null || :) # .gitprofile may not exist
  # Inspired by https://stackoverflow.com/questions/6318809/how-do-i-grab-an-ini-value-within-a-shell-script
  name=$(printf '%s\n' "$gitprofile" | sed -n "s/^ *name *= *[\"']*\([^\"']*\)[\"']* *$/\1/p")
  email=$(printf '%s\n' "$gitprofile" | sed -n "s/^ *email *= *[\"']*\([^\"']*\)[\"']* *$/\1/p")
  if [ ! "$name" ] || [ ! "$email" ]; then
    printf '%b\n' "${RED}error: No $profile profile${NC}" >&2
    exit 1
  fi
fi

git config "${global:---local}" user.name "$name"
git config "${global:---local}" user.email "$email"
printf '%b\n' "${GREEN}Watsuuup $name <$email>${NC}"
