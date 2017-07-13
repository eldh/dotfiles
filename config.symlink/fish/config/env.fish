set -x NODE_PATH /usr/local/lib/node
set -x EDITOR ne
set -x DOTFILES ~/dotfiles

# PATH Setup

# Languages
set PATH /usr/local/sbin $PATH # homebrew
set PATH /Library/Frameworks/Python.framework/Versions/2.7/bin $PATH # python
set PYTHONPATH /usr/local/lib/python2.7/site-packages $PYTHONPATH
set PYTHONPATH /Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/site-packages $PYTHONPATH

set PATH $DOTFILES/bin $PATH # local bins
