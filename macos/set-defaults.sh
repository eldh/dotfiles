#!/usr/bin/env bash
#
# macOS defaults, mirroring how this machine is actually set up (captured
# 2026-08 from System Settings). Run via `dot --macos`.
#
# Safe to re-run. No sudo needed. Restarts Dock, Finder and SystemUIServer
# at the end so changes apply immediately.

set -e

###############################################################################
# Appearance
###############################################################################

defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

###############################################################################
# Keyboard
###############################################################################

# Fast key repeat with a short initial delay.
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 30

# Full keyboard access: tab moves focus between all controls.
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Don't add a period on double-space.
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

###############################################################################
# Trackpad
###############################################################################

# Tap to click (built-in, bluetooth, and for the current host).
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

###############################################################################
# Dock, Mission Control & hot corners
###############################################################################

defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock tilesize -int 36
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock largesize -int 60
defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock show-recents -bool false

# Don't rearrange spaces based on most recent use.
defaults write com.apple.dock mru-spaces -bool false

# Hot corners: 1 = off, 2 = Mission Control, 3 = App windows, 4 = Desktop.
defaults write com.apple.dock wvous-tl-corner -int 4
defaults write com.apple.dock wvous-tl-modifier -int 0
defaults write com.apple.dock wvous-tr-corner -int 2
defaults write com.apple.dock wvous-tr-modifier -int 0
defaults write com.apple.dock wvous-bl-corner -int 1
defaults write com.apple.dock wvous-br-corner -int 3
defaults write com.apple.dock wvous-br-modifier -int 0

###############################################################################
# Finder & files
###############################################################################

# Show all file extensions, and hidden files too.
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true

defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

# List view by default; search the current folder, not This Mac.
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# No warning when changing a file extension.
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# New windows open in $HOME.
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://$HOME"

# Don't litter network shares with .DS_Store files.
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

###############################################################################
# Apply
###############################################################################

for app in Dock Finder SystemUIServer; do
  killall "$app" >/dev/null 2>&1 || true
done

echo "macOS defaults applied."
