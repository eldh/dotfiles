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
dot --macos    # the above, plus macOS defaults
dot --all      # everything (alias for --macos)
dot -e         # open the dotfiles directory in $EDITOR
```

Package lists are declarative: edit `homebrew/Brewfile` and `npm/packages.txt`
rather than any install script. macOS defaults live in `macos/set-defaults.sh`
and only run behind `--macos`, since they restart Dock/Finder/SystemUIServer.

### Accounts

- Github: https://help.github.com/en/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent && https://help.github.com/en/articles/adding-a-new-ssh-key-to-your-github-account

## Layout

- **bin/**: added to `$PATH`, available everywhere. Notable: `dot` (setup),
  `wt` (git worktree helper), `lunch` (the important one).
- **zsh/zshrc.symlink**: the entire zsh config, one file in thematic sections.
- **functions/**: zsh autoloaded functions and completions (`c`, `extract`).
- **\*.symlink**: any file or directory ending in `.symlink` gets symlinked
  into `$HOME` as a dotfile when you run `dot` (e.g. `config.symlink` →
  `~/.config`).

## Todo

- Script for generating ssh key
