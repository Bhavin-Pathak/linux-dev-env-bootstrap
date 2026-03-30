#!/bin/bash
# Author: Bhavin Pathak
# Description: Essential Desktop Apps (macOS)

set -e

BOLD='\033[1m'
BLUE='\033[1;34m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m'

print_msg() { echo -e "\n${BLUE}${BOLD}>>> $1...${NC}\n"; }

is_installed() {
    [ -d "/Applications/$1.app" ] || command -v "$2" &> /dev/null
}

ask_install() {
    local name=$1
    echo -e "${YELLOW}Install ${BOLD}$name${NC}${YELLOW}? [y/n]${NC}"
    read -p "> " choice
    case "$choice" in 
        [yY]*) return 0 ;;
        *) echo -e "${RED}Skipped $name.${NC}"; return 1 ;;
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

install_brew() {
    local name="$1"
    local brew_name="$2"
    
    if command -v "$brew_name" &> /dev/null; then
        echo -e "${GREEN}✔ $name is already installed. Skipped.${NC}"
        return
    fi
    if ask_install "$name"; then
        print_msg "Installing $name"
        brew install "$brew_name"
        echo -e "${GREEN}$name Installed.${NC}"
    fi
}

clear
echo -e "${BLUE}${BOLD}Essential Apps & Tools (macOS)${NC}"
echo -e "------------------------"

echo -e "\n${YELLOW}--- Communication ---${NC}"
install_cask "Slack" "slack" "Slack"
install_cask "Discord" "discord" "Discord"
install_cask "Zoom" "zoom" "zoom.us"
install_cask "Microsoft Teams" "microsoft-teams" "Microsoft Teams"
install_cask "WhatsApp" "whatsapp" "WhatsApp"
install_cask "Telegram" "telegram" "Telegram"

echo -e "\n${YELLOW}--- Media ---${NC}"
install_cask "Spotify" "spotify" "Spotify"
install_cask "VLC Media Player" "vlc" "VLC"
install_cask "OBS Studio" "obs" "OBS"
install_cask "Audacity" "audacity" "Audacity"
install_cask "Blender" "blender" "Blender"
install_cask "Figma" "figma" "Figma"

echo -e "\n${YELLOW}--- Utilities & Games ---${NC}"
install_cask "Flameshot (Screenshot Tool)" "flameshot" "Flameshot"
install_brew "Btop (Monitor)" "btop"
install_cask "Steam" "steam" "Steam"

echo -e "\n${GREEN}All Apps Setup Complete! 🚀${NC}\n"
