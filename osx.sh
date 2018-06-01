#!/bin/bash

sudo -v

brew bundle

# Sprinkle these around to avoid timeouts
sudo -v

model_xpath="/plist[@version='1.0']/array/dict/key[.='_items']/following-sibling::*[1]/dict/key[.='machine_model']/following-sibling::*[1]/text()"
is_laptop=`/usr/sbin/system_profiler -xml SPHardwareDataType | xmlstarlet sel -q -t -v "$model_xpath" 2>/dev/null | grep "^MacBook"`

# Pip is installed by virtue of homebrew by this point
pip install --upgrade pip
pip install --upgrade -r requirements.txt

sudo -v

RCRC=rcrc rcup -d .

## Display

# Automatically adjust brightness
defaults write com.apple.BezelServices dAuto -bool true
sudo defaults write /Library/Preferences/com.apple.iokit.AmbientLightSensor "Automatic Display Enabled" -bool true

# Subpixel font rendering on non-Apple LCDs
# 0 : Disabled
# 1 : Minimal
# 2 : Medium
# 3 : Smoother
# 4 : Strong
defaults write NSGlobalDomain AppleFontSmoothing -int 1

# Enable HiDPI display modes (requires restart)
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

## Dock 

# Icon size of Dock items
defaults write com.apple.dock tilesize -int 32

# Lock the Dock size
defaults write com.apple.dock size-immutable -bool true

# Dock magnification
defaults write com.apple.dock magnification -bool true

# Icon size of magnified Dock items
defaults write com.apple.dock largesize -int 72

# Minimization effect: 'genie', 'scale', 'suck'
defaults write com.apple.dock mineffect -string 'genie'

# Hide dock automatically
defaults write com.apple.dock autohide -bool true

# Set top right hot corner to start screensaver
defaults write com.apple.dock wvous-tr-corner -int 5
defaults write com.apple.dock wvous-tr-modifier -int 0

# Set top left hot corner to disable screensaver
defaults write com.apple.dock wvous-tl-corner -int 6
defaults write com.apple.dock wvous-tl-modifier -int 0

## Energy Saver

# Standby delay in seconds
# Default  : 3600
# 24 Hours : 86400
sudo pmset -a standbydelay 86400

# Power management settings
# `man pmset` for a full list of settings
if [[ "$is_laptop" != "" ]]; then
  # notebook: battery
  sudo pmset -b       \
    sleep         15  \
    disksleep     10  \
    displaysleep   5  \
    halfdim        1
  # notebook: power adapter
  sudo pmset -c       \
    sleep          0  \
    disksleep      0  \
    displaysleep  15  \
    halfdim        1  \
    autorestart    1  \
    womp           1
else
  # desktop
  sudo pmset          \
    sleep          0  \
    disksleep      0  \
    displaysleep  30  \
    halfdim        1

fi

## Keyboard

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set delay until repeat (in milliseconds)
# Long: 120
# Short: 15
defaults write NSGlobalDomain InitialKeyRepeat -int 25

# Set key repeat rate (minimum 1)
# Off: 300000
# Slow: 120
# Fast: 2
defaults write NSGlobalDomain KeyRepeat -int 2

# Full Keyboard Access
# In windows and dialogs, press Tab to move keyboard focus between:
# 1 : Text boxes and lists only
# 3 : All controls
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Use smart quotes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Set Double and Single quotes
defaults write NSGlobalDomain NSUserQuotesArray -array '"\""' '"\""' '"'\''"' '"'\''"'

# Use smart dashes
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 "<dict><key>enabled</key><false/></dict>"

## Misc

# Always show scrollbars
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

# Disable Resume system-wide
defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false

# Enable locate command and build locate database
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist 2>/dev/null

## Screen Saver

# Start after begin idle for time (in seconds)
defaults -currentHost write com.apple.screensaver idleTime -int 120

## Security

# Require password 5 seconds after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -bool true
defaults write com.apple.screensaver askForPasswordDelay -int 5

# Screeensaver setup

defaults -currentHost write com.apple.screensaver moduleDict -dict moduleName "Sproingies" path "$HOME/Library/Screen Savers/Sproingies.saver" type -int 0
defaults -currentHost write org.jwz.xscreensaver.Sproingies count -int 10

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Disable automatic login
sudo defaults delete /Library/Preferences/com.apple.loginwindow autoLoginUser &> /dev/null

# Disable Infared Remote
sudo defaults write /Library/Preferences/com.apple.driver.AppleIRController DeviceEnabled -bool false

## Sound

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

## Trackpad

# Disable "natural" (Lion-style) scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

## Users

# Don't allow guests to login to this computer
sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false

sudo killall -hup cfprefsd
sudo killall -hup Dock

## SlowQuitApps
defaults write com.dteoh.SlowQuitApps delay -int 1500

# Blacklist mode
defaults write com.dteoh.SlowQuitApps invertList -bool YES

# Slow quit on browsers and terminals
defaults write com.dteoh.SlowQuitApps whitelist -array-add com.googlecode.iterm2
defaults write com.dteoh.SlowQuitApps whitelist -array-add io.alacritty

defaults write com.dteoh.SlowQuitApps whitelist -array-add com.google.Chrome
defaults write com.dteoh.SlowQuitApps whitelist -array-add org.mozilla.firefoxdeveloperedition

brew cu --no-brew-update -af slowquitapps

echo "Done. Note that some of these changes require a logout/restart to take effect."
