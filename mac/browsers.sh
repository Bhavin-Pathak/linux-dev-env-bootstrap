#!/bin/bash
# Author: Bhavin Pathak
# Description: Modern & Classic Web Browsers Installer (macOS)

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
    # Check if app exists
    [ -d "/Applications/$1.app" ] || brew list --cask "$2" &>/dev/null
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

install_cask() {
    local name="$1"
    local cask_name="$2"
    local app_name="$3"
    
    if is_installed "$app_name" "$cask_name"; then
        echo -e "${GREEN}✔ $name is already installed. Skipped.${NC}"
        return
    fi
    
    if ask_install "$name"; then
        print_msg "Installing $name"
        brew install --cask "$cask_name"
        echo -e "${GREEN}$name Installed.${NC}"
    fi
}

# --- Main ---

clear
echo -e "${BLUE}${BOLD}Web Browser Setup (macOS)${NC}"
echo -e "------------------------"

# Ensure brew is installed
if ! command -v brew &> /dev/null; then
    echo -e "${RED}Homebrew is not installed. Please run terminal.sh first or install it manually.${NC}"
    exit 1
fi

install_cask "Google Chrome" "google-chrome" "Google Chrome"
install_cask "Microsoft Edge" "microsoft-edge" "Microsoft Edge"
install_cask "Brave Browser" "brave-browser" "Brave Browser"
install_cask "Firefox" "firefox" "Firefox"
install_cask "Chromium" "chromium" "Chromium"
install_cask "Vivaldi" "vivaldi" "Vivaldi"
install_cask "Opera" "opera" "Opera"
install_cask "Librewolf" "librewolf" "Librewolf"
install_cask "Tor Browser" "tor-browser" "Tor Browser"

echo -e "\n${GREEN}Browser Setup Complete! 🌐${NC}\n"
