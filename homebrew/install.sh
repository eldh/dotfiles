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

brew install zsh
brew tap homebrew/versions
brew install zsh-completions
brew install zsh-syntax-highlighting

command -v zsh | sudo tee -a /etc/shells
chsh -s /usr/local/bin/zsh

brew install tmux

# Install more recent versions of some OS X tools.
brew install vim --override-system-vi
brew install homebrew/dupes/grep
brew install homebrew/dupes/openssh
brew install homebrew/dupes/screen
brew install homebrew/php/php55 --with-gmp

# Install other useful binaries.
brew install ack
brew install git
brew install git-lfs
brew install speedtest_cli

brew install node

brew install caskroom/cask/brew-cask
brew cask install alfred
brew cask alfred link
brew cask install google-chrome
brew cask install google-chrome-canary
brew cask install firefoxdeveloperedition
brew cask install bettertouchtool
brew cask install flux
brew cask install dash
brew cask install spotify
brew cask install slack
brew cask install atom
brew cask install github-desktop
brew cask install sequel-pro
brew cask install dropbox
brew cask install mailbox
brew cask install onepassword
brew cask install transmission
brew tap caskroom/fonts
brew cask install font-inconsolata
brew cask install font-input
brew cask install font-fira-sans
brew cask install font-fira-code
brew cask install font-source-sans-pro
brew cask install font-source-code-pro
brew cask install font-lato
brew cask install font-abril-fatface
brew cask install font-crimson-text
brew cask install font-libre-baskerville
brew cask install font-roboto-slab
brew cask install font-roboto
brew cask install font-roboto-mono
brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv betterzipql webp-quicklook suspicious-package
brew cask cleanup

# Remove outdated versions from the cellar.
brew cleanup

exit 0
