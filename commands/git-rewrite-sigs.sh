#!/bin/bash
set -euo pipefail

FILTER_BRANCH_SQUELCH_WARNING=1 git filter-branch -f --msg-filter "sed /^Signed-off-by:/d"
FILTER_BRANCH_SQUELCH_WARNING=1 git filter-branch -f --env-filter '
name="$(git config --get user.name)"
email="$(git config --get user.email)"
if [ "$GIT_AUTHOR_NAME" != "$name" ] || [ "$GIT_AUTHOR_EMAIL" != "$email" ]; then
    export GIT_AUTHOR_NAME="$name"
    export GIT_AUTHOR_EMAIL="$email"
fi
' --tag-name-filter cat -- --branches --tags
git rebase --signoff --root
