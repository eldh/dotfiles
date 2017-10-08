set -x NODE_PATH /usr/local/lib/node
set -x EDITOR ne
set -x DOTFILES ~/dotfiles

# PATH Setup

# Languages
set PATH /usr/local/sbin $PATH # homebrew
set PATH ~/Library/Python/3.6/bin $PATH # python stuff
set PATH $DOTFILES/bin $PATH # local bins
