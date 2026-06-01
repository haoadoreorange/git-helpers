#!/bin/sh
set -eu
# Inspired by https://www.git-tower.com/learn/git/faq/change-author-name-email

name=$(git config --get user.name)
email=$(git config --get user.email)

FILTER_BRANCH_SQUELCH_WARNING=1 \
  OLD_NAME="${1:?usage: $(basename "$0") <old name>}" \
  NEW_NAME="$name" \
  NEW_EMAIL="$email" \
  git filter-branch -f \
  --env-filter '
    if [ "$GIT_AUTHOR_NAME" = "$OLD_NAME" ]; then
      export GIT_AUTHOR_NAME="$NEW_NAME"
      export GIT_AUTHOR_EMAIL="$NEW_EMAIL"
    fi
  ' \
  --msg-filter 'sed "/^Signed-off-by:/d" | sed -e "\$a\\" -e "Signed-off-by: $NEW_NAME <$NEW_EMAIL>"' \
  --tag-name-filter cat -- --branches --tags
