#!/bin/bash
# Author: Bhavin Pathak
# Description: Modern & Classic Web Browsers Installer

set -e

# Styling
BOLD='\033[1m'
BLUE='\033[1;34m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m'

print_msg() {
    echo -e "\n${BLUE}${BOLD}>>> $1...${NC}\n"
}

is_installed() {
    command -v "$1" &> /dev/null
}

ask_install() {
    local name=$1
    echo -e "${YELLOW}Install ${BOLD}$name${NC}${YELLOW}? [y/n]${NC}"
    read -p "> " choice
    case "$choice" in 
        [yY]*) return 0 ;;
        *) 
            echo -e "${RED}Skipped $name.${NC}"
            return 1 
            ;;
    esac
}

check_and_ask() {
    local name="$1"
    local check_cmd="$2"
    local install_func="$3"
    local check_type="${4:-command}"

    local already_installed=false

    if [ "$check_type" == "dpkg" ]; then
        if dpkg -l | grep -q "$check_cmd"; then already_installed=true; fi
    elif [ "$check_type" == "snap" ]; then
        if snap list 2>/dev/null | grep -q "$check_cmd"; then already_installed=true; fi
    else 
        if is_installed "$check_cmd"; then already_installed=true; fi
    fi

    if [ "$already_installed" = true ]; then
        echo -e "${GREEN}✔ $name is already installed. Skipped.${NC}"
    else
        if ask_install "$name"; then
            $install_func
        fi
    fi
}

# --- Installers ---

install_chrome() {
    print_msg "Installing Google Chrome"
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O chrome.deb
    sudo apt install ./chrome.deb -y
    rm chrome.deb
    echo -e "${GREEN}Chrome Installed.${NC}"
}

install_brave() {
    print_msg "Installing Brave Browser (Snap)"
    sudo snap install brave
    echo -e "${GREEN}Brave Installed.${NC}"
}

install_firefox() {
    print_msg "Installing Firefox (Snap)"
    # Ensure snap is installed (handled in main)
    sudo snap install firefox
    echo -e "${GREEN}Firefox Installed.${NC}"
}

install_chromium() {
    print_msg "Installing Chromium (Snap)"
    sudo snap install chromium
    echo -e "${GREEN}Chromium Installed.${NC}"
}

install_edge() {
    print_msg "Installing Microsoft Edge"
    wget "https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-stable/microsoft-edge-stable_145.0.3800.58-1_amd64.deb?brand=M102" -O edge.deb
    sudo apt install ./edge.deb -y
    rm edge.deb 
    echo -e "${GREEN}Edge Installed.${NC}"
}

install_vivaldi() {
    print_msg "Installing Vivaldi (Snap)"
    sudo snap install vivaldi
    echo -e "${GREEN}Vivaldi Installed.${NC}"
}

install_opera() {
    print_msg "Installing Opera (Snap)"
    sudo snap install opera
    echo -e "${GREEN}Opera Installed.${NC}"
}

install_librewolf() {
    print_msg "Installing Librewolf"
    sudo apt update
    if ! is_installed extrepo; then
        sudo apt install extrepo -y
    fi
    sudo extrepo enable librewolf
    sudo extrepo update librewolf
    sudo apt update
    sudo apt install librewolf -y
    echo -e "${GREEN}Librewolf Installed.${NC}"
}

install_tor() {
    print_msg "Installing Tor Browser"
    # Download Tor Browser
    wget "https://dist.torproject.org/torbrowser/15.0.5/tor-browser-linux-x86_64-15.0.5.tar.xz" -O tor.tar.xz
    # Extract Tor Browser
    print_msg "Extracting Tor Browser..."
    tar -xf tor.tar.xz
    # Move to home directory if not already there
    if [ -d "tor-browser" ]; then
        mv tor-browser "$HOME/tor-browser"
    fi
    # Clean up
    rm tor.tar.xz
    echo -e "${GREEN}Tor Browser downloaded to $HOME/tor-browser.${NC}"
    echo -e "${YELLOW}Run it with: $HOME/tor-browser/start-tor-browser.desktop${NC}"
}

# --- Main ---

clear
echo -e "${BLUE}${BOLD}Web Browser Setup${NC}"
echo -e "------------------------"

if ! is_installed snap; then
    echo -e "${YELLOW}Installing Snapd (Required for Brave, Opera, Chromium, Vivaldi)${NC}"
    sudo apt update && sudo apt install snapd -y
fi

check_and_ask "Google Chrome" "google-chrome" install_chrome
check_and_ask "Microsoft Edge" "microsoft-edge-stable" install_edge
check_and_ask "Brave Browser" "brave" install_brave "snap"
check_and_ask "Firefox" "firefox" install_firefox "snap"
check_and_ask "Chromium" "chromium" install_chromium "snap"
check_and_ask "Vivaldi" "vivaldi" install_vivaldi "snap"
check_and_ask "Opera" "opera" install_opera "snap"
check_and_ask "Librewolf" "librewolf" install_librewolf
check_and_ask "Tor Browser" "torbrowser-launcher" install_tor

echo -e "\n${GREEN}Browser Setup Complete! 🌐${NC}\n"
