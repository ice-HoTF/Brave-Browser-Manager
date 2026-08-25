#!/bin/bash

WORK_DIR="/home/$USER/Downloads/Brave"
DEST_DIR="/home/$USER/Brave-Browser"
SOURCE_BRAVE="$WORK_DIR/opt/brave.com/brave"


#local="1.93.137"
local=$( [ -x "/home/$USER/Brave-Browser/brave" ] && /home/$USER/Brave-Browser/brave --version 2>/dev/null | awk '{print $3}' | cut -d'.' -f2- || echo "NOT_INSTALLED" )
remote=$(curl -s https://api.github.com/repos/brave/brave-browser/releases/latest | grep -Po '"tag_name":\s*"\K[^"]*' | sed 's/v//')

if [ "$local" != "$remote" ]; then
    [ "$local" = "NOT_INSTALLED" ] && mkdir -p "$DEST_DIR"
    echo ""
    echo "Update available"
#if [ "$local" != "$remote" ]; then
    echo ""
    echo "Current Version: $local"
    echo "Latest Version: $remote"
    echo ""
# 1: CHECK AND CREATE WORKING FOLDER

if [ ! -d "$WORK_DIR" ]; then
    mkdir -p "$WORK_DIR"
fi
echo "Downloading Brave-Browser"

# 2: DOWNLOAD AND EXTRACT

curl -s https://api.github.com/repos/brave/brave-browser/releases/latest | \
grep -oP '"browser_download_url":\s*"\K[^"]*_amd64\.deb' | \
grep -v symbols | \
head -1 | \
xargs -I{} sh -c '
    curl -LO {}
    ar x $(basename {}) --output='"$WORK_DIR"'
    tar -xf '"$WORK_DIR"'/data.tar.* -C '"$WORK_DIR"'
'
echo "Copying Files to Destination Directory"

# 3: COPY ONLY BRAVE FOLDER TO DESTINATION

if [ -d "$SOURCE_BRAVE" ]; then
    cp -rf "$SOURCE_BRAVE"/* "$DEST_DIR/"
fi
echo ""
echo "Cleaning Up Setup Files: /home/$USER/Downloads/Brave/"
rm -rf /home/$USER/Downloads/Brave
echo "Done"
echo ""
echo "Copying ICON to /home/$USER/Brave-Browser/"
cp brave.jpg /home/$USER/Brave-Browser/
echo "Done"
echo ""
echo "Creating Desktop File: /home/$USER/.local/share/applications/brave.desktop/"
[ ! -f "/home/$USER/.local/share/applications/brave.desktop" ] && cat > /home/$USER/.local/share/applications/brave.desktop << 'EOF'
[Desktop Entry]
Categories=Network;WebBrowser;
Comment=
Exec=sh -c "exec /home/$USER/Brave-Browser/brave"
Icon=/home/$USER/Brave-Browser/brave.jpg
MimeType=text/html;text/xml;application/xhtml+xml;x-scheme-handler/http;x-scheme-handler/https;
Name=Brave Browser
NoDisplay=false
Path=
PrefersNonDefaultGPU=false
StartupNotify=true
StartupWMClass=Brave-browser
Terminal=false
TerminalOptions=
Type=Application
X-KDE-SubstituteUID=false
X-KDE-Username=
EOF

echo "Done"
echo ""
echo "Copying Desktop File"
cp brave.desktop /home/$USER/.local/share/applications/
sed -i "s|\$USER|$USER|g" /home/$USER/.local/share/applications/brave.desktop
else
    echo ""
    echo "No Update Available"
    echo ""
    echo "Current Version: $local"
    echo "Latest Version: $remote"
    echo ""
fi
