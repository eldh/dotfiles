# eldh does dotfiles

## Install

Run this:

```sh
git clone https://github.com/eldh/dotfiles.git ~/dotfiles
cd ~/dotfiles
script/bootstrap
```

This will symlink the appropriate files in `dotfiles` to your home directory.
Everything is configured and tweaked within `~/dotfiles`.

### Preferences
- VS Code - Make sure that install script has run. It should symlink preferences from dotfiles.
- BetterTouchTools: Import preset

### Accounts
- Github: https://help.github.com/en/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent && https://help.github.com/en/articles/adding-a-new-ssh-key-to-your-github-account

### Maintainance
`dot` is a simple script that installs some dependencies, sets sane OS X
defaults, and so on. Tweak this script, and occasionally run `dot` from
time to time to keep your environment fresh and up-to-date. You can find
this script in `bin/`.


## Components

There's a few special files in the hierarchy.

- **bin/**: Anything in `bin/` will get added to your `$PATH` and be made
  available everywhere.
- **topic/\*.fish**: Any files ending in `.fish` get loaded into your
  environment.
- **topic/path.fish**: Any file named `path.fish` is loaded first and is
  expected to setup `$PATH` or similar.
- **topic/completion.fish**: Any file named `completion.fish` is loaded
  last and is expected to setup autocomplete.
- **topic/\*.symlink**: Any files ending in `*.symlink` get symlinked into
  your `$HOME`. This is so you can keep all of those versioned in your dotfiles
  but still keep those autoloaded files in your home directory. These get
  symlinked in when you run `script/bootstrap`.


## Todo
- Script for generating ssh key
- Ensure osx settings don't hang install script
