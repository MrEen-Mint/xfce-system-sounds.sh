#!/bin/bash

##########
#
# Project     : xfce-system-sounds.sh
# Started     : June 20, 2020
# Author      : MrEen
# Description : One script to get system sounds working on Linux Mint Xfce
#
##########

# First make sure we're running Xfce
if [ ! $(printenv XDG_CURRENT_DESKTOP) == XFCE ]; then
    echo "This script was written for Xfce only, aborting."
    exit 1
fi

# Make sure the necessary settings are set
if [ $(xfconf-query -c xsettings -p /Net/EnableEventSounds) ]; then
    xfconf-query -c xsettings -p /Net/EnableEventSounds -s true
else
    xfconf-query -c xsettings -p /Net/EnableEventSounds -n -t 'bool' -s true
fi

if [ $(xfconf-query -c xsettings -p /Net/EnableInputFeedbackSounds) ]; then
    xfconf-query -c xsettings -p /Net/EnableInputFeedbackSounds -s true
else
    xfconf-query -c xsettings -p /Net/EnableInputFeedbackSounds -n -t 'bool' -s true
fi

if [ $(xfconf-query -c xsettings -p /Net/SoundThemeName) ]; then
    xfconf-query -c xsettings -p /Net/SoundThemeName -s LinuxMint
else
    xfconf-query -c xsettings -p /Net/SoundThemeName -n -t string -s LinuxMint
fi

# Add the necessary environment variable
if [ ! $(grep GTK_MODULES ~/.profile) ]; then
    echo "GTK_MODULES=\"\$GTK_MODULES:canberra-gtk-module\"" >> ~/.profile
    echo "export GTK_MODULES" >> ~/.profile
fi

# Make sure the necessary programs are installed
if [ ! $(which canberra-gtk-play) ]; then
    echo "The program gnome-session-canberra must be installed for system sounds to work."
    echo "To keep this script free from requiring a password, you must install this yourself."
    echo "The simplest solution is to run this in the terminal: apt install gnome-session-canberra"
fi

if [ ! $(which sox) ]; then
    echo "The program sox must be installed for system sounds to work."
    echo "To keep this script free from requiring a password, you must install this yourself."
    echo "The simplest solution is to run this in the terminal: apt install sox"
fi

# Our work here is done, so inform the user
echo "The script has completed. If you were informed that you need to install both"
echo "canberra-gtk-play and sox, you can save a step by running this in the terminal:"
echo "apt install canberra-gtk-play sox"

exit 0
