set -x NODE_PATH /usr/local/lib/node
set -x EDITOR ne
set -x DOTFILES ~/dotfiles

# PATH Setup

# Languages
set PATH /usr/local/sbin $PATH # homebrew
set PATH /opt/homebrew/bin $PATH # homebrew
set PATH $DOTFILES/bin $PATH # local bins
set PATH ~/.opam/system/bin $PATH # opam
