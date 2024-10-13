#!/bin/sh
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Check for Homebrew
if test ! $(which brew)
then
  echo "  Installing Homebrew for you."

  # Install the correct homebrew for each OS type
  if test "$(uname)" = "Darwin"
  then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  elif test "$(expr substr $(uname -s) 1 5)" = "Linux"
  then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/linuxbrew/go/install)"
  fi

fi

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install homebrew packages

# Install GNU core utilities (those that come with OS X are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
sudo ln -s /usr/local/bin/gsha256sum /usr/local/bin/sha256sum

chsh -s /bin/zsh

brew install nano
brew install ne

# Install other useful binaries.
brew install ack
brew install git
brew install git-lfs
brew install ccat
brew install fzf
brew install node@20
brew install python
brew install yarn
brew install gpg
brew install scc
brew install cloc
brew install gh

# zsh stuff
brew install starship
brew install zsh-history-substring-search
brew install zsh-autosuggestions
brew install olets/tap/zsh-abbr

brew install homebrew/cask/alfred
brew install homebrew/cask/warp
brew install homebrew/cask/brave-browser
brew install homebrew/cask/bettertouchtool
brew install homebrew/cask/spotify
brew install homebrew/cask/slack
brew install homebrew/cask/transmission
brew install homebrew/cask/visual-studio-code
brew install homebrew/cask/kap
brew install homebrew/cask/1password
brew install homebrew/cask/gitup
brew install homebrew/cask/vlc
brew install homebrew/cask/firefox
brew install homebrew/cask/gitup
brew install homebrew/cask/postico

brew install homebrew/cask-versions/safari-technology-preview

brew tap homebrew/cask-fonts
brew install font-inconsolata
brew install font-input
brew install font-fira-sans
brew install font-fira-code
brew install font-hasklig
brew install font-monoid
brew install font-lato
brew install font-pacifico
brew install font-abril-fatface
brew install font-roboto-slab
brew install font-noto-sans
brew install font-inter
brew install font-noto-serif
# brew install font-noto-mono
brew install qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv webpquicklook suspicious-package qlvideo
brew cleanup

# Remove outdated versions from the cellar.
brew cleanup

exit 0
