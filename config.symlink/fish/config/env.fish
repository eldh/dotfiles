set -x NODE_PATH /usr/local/lib/node
set -x EDITOR atom -nw

# PATH Setup

# Languages
set PATH /usr/local/sbin $PATH # homebrew
set PYTHONPATH /usr/local/lib/python2.7/site-packages $PYTHONPATH

set PATH $DOTFILES/bin $PATH # local bins
