# A collection of git hooks and common commands I use

Some are just bare bone command, some are script that make use of multiple
commands, found in `commands/`

### hooks

`commit-msg`: hook from
[git-good-commit](https://github.com/tommarshall/git-good-commit).

`pre-commit`: This hook checks and enforces the author signature (name & email)
based on what it found in the `.sig` file in the current git repo. If there is
no `.sig` file the hook doesn't do anything. You can define a `.sig` file as

```sh
name="Foo Baz"
email="foo@mail.com"
```

### commands

##### Rewrite all the author signature to the current signature. WARNING: it rewrites the whole git history (remove all `Sign-off-by` lines and re-sign), make sure you understand what you're doing.

`commands/git-write-sigs.sh`

##### Delete remote tags.

`git push origin --delete $(git tag -l)`. Pushing once should be faster than
multiple times

##### Delete local tags.

`git tag -d $(git tag -l)`

##### Delete remote branches with prefix (example)

`git branch -a | grep branch-prefix | sed 's|remotes/origin/||' | xargs git push -d origin`

### hooks installation

`curl -L https://raw.githubusercontent.com/haoadoreorange/git-helpers/main/install.sh | bash`
