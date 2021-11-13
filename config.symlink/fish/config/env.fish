set -x NODE_PATH /usr/local/lib/node
set -x EDITOR nano
set -x DOTFILES ~/dotfiles

# PATH Setup

# Languages
set PATH /opt/homebrew/opt/node@16/bin $PATH # homebrew
set PATH /usr/local/sbin $PATH # homebrew
set PATH /opt/homebrew/bin $PATH # homebrew
set PATH $DOTFILES/bin $PATH # local bins
