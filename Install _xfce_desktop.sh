#!/bin/bash

echo "Updating packages..."
pkg update -y && pkg upgrade -y

echo "Installing XFCE4 and other necessary packages..."
pkg install xfce4 xfce4-whiskermenu-plugin xfce4-terminal wget curl -y

# Prompt to install VS Code
read -p "Do you want to install Visual Studio Code? (y/n): " install_vscode
if [[ $install_vscode == "y" ]]; then
    echo "Installing Visual Studio Code..."
    pkg install code-server -y
fi

# Download and extract Whitesur theme and Papirus icons
echo "Installing Whitesur theme and Papirus icon theme..."
mkdir -p ~/.themes ~/.icons
cd ~/.themes && wget https://github.com/vinceliuice/WhiteSur-gtk-theme/archive/refs/heads/master.zip && unzip master.zip && rm master.zip
cd ~/.icons && wget https://github.com/PapirusDevelopmentTeam/papirus-icon-theme/archive/refs/heads/master.zip && unzip master.zip && rm master.zip

# Browser selection: Firefox or Chromium
echo "Which browser do you want to install?"
select browser in "Firefox" "Chromium"; do
    case $browser in
        Firefox ) pkg install firefox -y; break;;
        Chromium ) pkg install chromium -y; break;;
    esac
done

# Prompt to choose VNC or Termux-X11
echo "Do you want to use VNC or Termux-X11?"
select display_type in "VNC" "Termux-X11"; do
    case $display_type in
        VNC )
            echo "Installing and configuring VNC server..."
            pkg install tigervnc -y
            vncserver :1
            echo "If you don't have RealVNC Viewer installed, type 'y' to download it from Play Store."
            read -p "Download RealVNC Viewer? (y/n): " download_vncviewer
            if [[ $download_vncviewer == "y" ]]; then
                termux-open-url "https://play.google.com/store/apps/details?id=com.realvnc.viewer.android"
            fi
            break;;
        Termux-X11 )
            echo "Installing Termux-X11..."
            pkg install termux-x11 -y
            wget https://raw.githubusercontent.com/LinuxDroidMaster/Termux-Desktops/main/scripts/termux_native/startxfce4_termux.sh -O ~/bin/desktop
            chmod +x ~/bin/desktop
            echo "Installation complete. Please close Termux and reopen it. Then type 'desktop' to start the XFCE4 desktop environment."
            read -p "Type 'y' to close Termux now: " close_termux
            if [[ $close_termux == "y" ]]; then
                exit
            fi
            break;;
    esac
done

echo "XFCE4 desktop setup is complete.
