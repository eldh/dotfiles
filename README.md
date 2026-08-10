# eldh does dotfiles

## Install

First run:

```sh
git clone https://github.com/eldh/dotfiles.git ~/dotfiles
cd ~/dotfiles
script/bootstrap
```

`script/bootstrap` is just a first-run wrapper around `dot --all`. It symlinks
the versioned files into your home directory, installs Homebrew + packages, and
applies macOS defaults. Everything is configured and tweaked within `~/dotfiles`.

### Keeping the setup fresh

`dot` (in `bin/`, so it's on your `$PATH`) is the single, idempotent command.
It's safe to run any time and always converges the machine to the "right" state:

```sh
dot            # symlinks + agent instructions + brew bundle + npm globals
dot --macos    # the above, plus macOS defaults + Terminal.app theme
dot --all      # everything (alias for --macos)
dot -e         # open the dotfiles directory in $EDITOR
```

Package lists are declarative: edit `homebrew/Brewfile` and `npm/packages.txt`
rather than any install script. macOS defaults live in `macos/set-defaults.sh`
and only run behind `--macos`, since they need `sudo` and force-quit apps.

### Preferences

- BetterTouchTools: Import preset

### Accounts

- Github: https://help.github.com/en/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent && https://help.github.com/en/articles/adding-a-new-ssh-key-to-your-github-account

## Components

There's a few special files in the hierarchy.

- **bin/**: Anything in `bin/` will get added to your `$PATH` and be made
  available everywhere.
- **topic/\*.zsh**: Any files ending in `.zsh` get loaded into your
  environment.
- **topic/path.zsh**: Any file named `path.zsh` is loaded first and is
  expected to setup `$PATH` or similar.
- **topic/completion.zsh**: Any file named `completion.zsh` is loaded
  last and is expected to setup autocomplete.
- **topic/\*.symlink**: Any files ending in `*.symlink` get symlinked into
  your `$HOME`. This is so you can keep all of those versioned in your dotfiles
  but still keep those autoloaded files in your home directory. These get
  symlinked in when you run `dot`.

## jj (jujutsu) helpers

Defined in `zsh/jj.zsh`. Bookmark names are pasted directly from Linear.

Single-workspace:

- `jjstart <name>` — fetch, branch off `trunk()`, create bookmark.
- `jjsw <rev>` — switch working copy to another change/bookmark.
- `jjon <rev>` — fetch, then start a new change on top of `<rev>`.
- `jjpush` — first push of a bookmark (`--allow-new`).
- `jjrepush` — `jj tug` then `jj git push` to update an existing PR.
- `jjpr [gh args...]` — push current change's bookmark and `gh pr create`.
- `jjremote` — fetch and list all remote bookmarks.
- `jjcheat` — print a git→jj cheat sheet.

Multi-workspace (parallel agents + dedicated dev workspace, sibling dirs
named `<repo>-<workspace>`):

- `jjws-new <name> [rev]` — create sibling workspace at `<repo>-<name>`.
- `jjws-dev` — create the dedicated `dev` workspace.
- `jjws-cd <name>` — `cd` to a sibling workspace from anywhere in the repo.
- `jjws-ls` — list workspaces (`jj workspace list`).
- `jjws-rm <name>` — forget a workspace and `rm -rf` its dir (confirms first).
- `jjdev <bookmark>` — point the dev workspace at `<bookmark>`; dev server
  hot-reloads. Does not change the calling shell's cwd.
- `jjdev-this` — same, but uses the bookmark in the workspace you're
  currently in. Creates the dev workspace if it doesn't exist.
- `jjlinear <user/branch>` — if the branch is known locally (you've fetched
  recently), track it; otherwise create it locally on `trunk()`. Does **not**
  fetch — run `jj git fetch` first when needed. Creates a workspace named
  after the part after `/` and `cd`s in.

## Todo

- Script for generating ssh key
- Ensure osx settings don't hang install script
