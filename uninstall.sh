#!/bin/bash

echo "Uninstalling Brave Browser..."

# Remove Brave directory
if [ -d "/home/$USER/Brave-Browser" ]; then
    rm -rf "/home/$USER/Brave-Browser"
    echo "Brave-Browser Uninstalled"
else
    echo "Brave-Browser: Nothing to Uninstall."
fi

# Remove desktop file
DESKTOP="/home/$USER/.local/share/applications/brave.desktop"
if [ -f "$DESKTOP" ]; then
    rm "$DESKTOP"
    echo "brave.desktop Removed From: $DESKTOP"
else
    echo "brave.desktop: Nothing to Uninstall."
fi

echo "Done"
