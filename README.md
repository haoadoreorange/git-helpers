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

or run the provided command `git sig --init "Foo Baz" "foo@mail.com"` in a git
repo (See [below](#commands)).

### hooks installation

`curl -L https://raw.githubusercontent.com/haoadoreorange/git-helpers/main/install.sh | sh`

### commands

##### Rewrite all the author signature to the current signature. WARNING: it rewrites the whole git history (remove all `Sign-off-by` lines and re-sign), make sure you understand what you're doing.

`commands/git-write-sigs.sh`

##### Changing quickly between different git signatures

`commands/git-sig.sh`

Beside the hooks, the install script also installs a git command `git-sig`. The
simpliest use is changing git name & email with 1 command
`git sig "Foo Baz" "foo@mail.com"`. When run with `--init`, it creates a `.sig`
file in the git repo for the `pre-commit` hook above. It also allows changing
quickly between different git signatures "profile" using a `~/.sig.profile`
file.

```ini
[default]
    name="Foo Baz"
    email="foo@mail.com"

[school]
    name="Foo Baz"
    email="foo@school.com"
```

and then run `git sig profile-name`. Running without argument will use the
default profile.

##### Delete remote tags.

`git push origin --delete $(git tag -l)`. Pushing once should be faster than
multiple times

##### Delete local tags.

`git tag -d $(git tag -l)`

##### Delete remote branches with prefix (example)

`git branch -a | grep branch-prefix | sed 's|remotes/origin/||' | xargs git push -d origin`

##### Split existing repository into submodules

```sh
# split the "main repo"
git subtree split -P path -b <branch>

# Create your repository, and get git url

# add remote for branch
git remote add submodule <url>

# push the submodule
git push -u submodule <branch>:master

# remove path
git rm -r path

# Stage and commit changes
git add -A
git commit -m 'Remove <path> for submodule replacement'

# add the submodule 
git submodule add <url> <path>

# and once your submodule is added commit the .gitmodules file 
```
