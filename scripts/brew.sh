#!/usr/bin/env zsh
# Installation script for Homebrew packages
# by Yuzhou (Joe) Mo <joe.mo@berkeley.edu>
# License: GNU GPLv3

packages=(
  # Updated versions of outdated macOS tools
  coreutils
  grep
  vim
  openssh
  php

  # Useful CLI tools
  ack
  ffmpeg
  gh
  git
  gnupg
  mas
  neovim
  nvm
  openjdk
  p7zip
  pigz
  postgresql
  tmux
  tree
  wget
  youtube-dl
  zopfli

  # Casks
  android-platform-tools
  balenaetcher
  bitwarden
  deluge
  discord
  eloston-chromium
  figma
  firefox
  flux
  imageoptim
  insomnia
  keepassxc
  keka
  kitty
  ledger-live
  libreoffice
  lulu
  mactex
  miniconda
  obsidian
  protonmail-bridge
  protonvpn
  signal
  slack
  spotify
  standard-notes
  thunderbird
  tor-browser
  visual-studio-code
  vlc
  zoom
)

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `brew.sh` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Check to see if Homebrew is installed, and install it if it is not
command -v brew >/dev/null 2>&1 || (echo "Installing homebrew..." && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)")

# Turn off analytics
brew analytics off

echo "Upgrading any already-installed formulae..."
brew upgrade

echo "Installing homebrew packages..."

# Save an associative array of already-installed packages
declare -A already_installed
for i in `brew list`; do
  already_installed["$i"]=1
done

# Set to 1 if anything is installed
installed_flag=0

# Install packages if they are not already installed
for i in ${packages[@]}; do
  if [[ "${already_installed["$i"]}" -ne 1 ]]; then
    brew install "$i"
    installed_flag=1
  else
    echo "Package already installed: $i"
  fi
done

# Disable "Are you sure you want to open this application?" dialog on installed apps
[[ "$installed_flag" -eq 1 ]] && \
  echo "Disabling Gatekeeper quarantine on all installed applications..."; \
  sudo xattr -dr com.apple.quarantine /Applications 2>/dev/null

echo "Removing outdated versions from cellar..."
brew cleanup
