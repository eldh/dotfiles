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
brew upgrade --all

# Install homebrew packages

# Install GNU core utilities (those that come with OS X are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
sudo ln -s /usr/local/bin/gsha256sum /usr/local/bin/sha256sum

brew install fish
brew tap homebrew/versions

command -v fish | sudo tee -a /etc/shells
chsh -s /usr/local/bin/fish

brew install tmux

# Install more recent versions of some OS X tools.
# brew install vim --override-system-vi
# brew install homebrew/dupes/grep
# brew install homebrew/dupes/openssh
# brew install homebrew/dupes/screen
# brew install homebrew/php/php55 --with-gmp

brew install ne

# clojurescript
# brew install rlwrap

# Install other useful binaries.
brew install ack
brew install git
brew install hub
brew install git-lfs
brew install ccat
brew install fzf
brew install node
brew install yarn
brew install gpg
brew install scc
brew install cloc

brew tap homebrew/cask-cask
brew install alfred
brew install kitty
brew install brave-browser
brew install bettertouchtool
brew install spotify
brew install slack
brew install transmission
brew install visual-studio-code
brew install kap
brew install 1password
brew install gitup
brew install vlc

brew install safari-technology-preview

brew tap homebrew/cask-fonts
brew install font-inconsolata
brew install font-input
brew install font-fira-sans
brew install font-fira-code
brew install font-hasklig
brew install font-monoid
brew install font-source-sans-pro
brew install font-source-code-pro
brew install font-lato
brew install font-pacifico
brew install font-abril-fatface
brew install font-crimson-text
brew install font-libre-baskerville
brew install font-roboto-slab
brew install font-roboto
brew install font-roboto-mono
brew install font-noto-sans
brew install font-inter
brew install font-noto-serif
# brew install font-noto-mono
brew install qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv betterzipql webpquicklook suspicious-package qlvideo
brew cleanup

# Remove outdated versions from the cellar.
brew cleanup

exit 0
