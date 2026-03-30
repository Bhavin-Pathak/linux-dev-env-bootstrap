#!/bin/bash
# Author: Bhavin Pathak
# Description: Essential Desktop Apps (Communication, Media, Gaming, Utilities)

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

install_slack() {
    print_msg "Installing Slack"
    sudo snap install slack
    echo -e "${GREEN}Slack Installed.${NC}"
}

install_discord() {
    print_msg "Installing Discord"
    sudo snap install discord
    echo -e "${GREEN}Discord Installed.${NC}"
}

install_zoom() {
    print_msg "Installing Zoom"
    wget https://zoom.us/client/latest/zoom_amd64.deb -O zoom.deb
    sudo apt install ./zoom.deb -y
    rm zoom.deb
    echo -e "${GREEN}Zoom Installed.${NC}"
}

install_teams() {
    print_msg "Installing Microsoft Teams"
    sudo snap install teams-for-linux
    echo -e "${GREEN}Teams Installed.${NC}"
}

install_whatsapp() {
    print_msg "Installing WhatsApp"
    sudo snap install whatsapp-for-linux
    echo -e "${GREEN}WhatsApp Installed.${NC}"
}

install_telegram() {
    print_msg "Installing Telegram"
    sudo snap install telegram-desktop
    echo -e "${GREEN}Telegram Installed.${NC}"
}

install_spotify() {
    print_msg "Installing Spotify"
    sudo snap install spotify
    echo -e "${GREEN}Spotify Installed.${NC}"
}

install_vlc() {
    print_msg "Installing VLC Media Player"
    sudo apt install vlc -y
    echo -e "${GREEN}VLC Installed.${NC}"
}

install_obs() {
    print_msg "Installing OBS Studio"
    sudo add-apt-repository ppa:obsproject/obs-studio -y
    sudo apt update
    sudo apt install obs-studio -y
    echo -e "${GREEN}OBS Installed.${NC}"
}

install_audacity() {
    print_msg "Installing Audacity"
    sudo snap install audacity
    echo -e "${GREEN}Audacity Installed.${NC}"
}

install_blender() {
    print_msg "Installing Blender"
    sudo snap install blender --classic
    echo -e "${GREEN}Blender Installed.${NC}"
}

install_figma() {
    print_msg "Installing Figma (Unofficial)"
    sudo snap install figma-linux
    echo -e "${GREEN}Figma Installed.${NC}"
}

install_flameshot() {
    print_msg "Installing Flameshot (Screenshot Tool)"
    sudo apt install flameshot -y
    echo -e "${GREEN}Flameshot Installed.${NC}"
}

install_gparted() {
    print_msg "Installing GParted"
    sudo apt install gparted -y
    echo -e "${GREEN}GParted Installed.${NC}"
}

install_btop() {
    print_msg "Installing Btop (Monitor)"
    sudo apt install btop -y
    echo -e "${GREEN}Btop Installed.${NC}"
}

install_steam() {
    print_msg "Installing Steam"
    sudo apt install steam-installer -y
    echo -e "${GREEN}Steam Installed.${NC}"
}

# --- Main ---

clear
echo -e "${BLUE}${BOLD}Essential Apps & Tools${NC}"
echo -e "------------------------"

if ! is_installed snap; then
    echo -e "${YELLOW}Installing Snapd (Required for many apps)${NC}"
    sudo apt update && sudo apt install snapd -y
fi

echo -e "\n${YELLOW}--- Communication ---${NC}"
check_and_ask "Slack" "slack" install_slack "snap"
check_and_ask "Discord" "discord" install_discord "snap"
check_and_ask "Zoom" "zoom" install_zoom
check_and_ask "Microsoft Teams" "teams-for-linux" install_teams "snap"
check_and_ask "WhatsApp" "whatsapp-for-linux" install_whatsapp "snap"
check_and_ask "Telegram" "telegram-desktop" install_telegram "snap"

echo -e "\n${YELLOW}--- Media ---${NC}"
check_and_ask "Spotify" "spotify" install_spotify "snap"
check_and_ask "VLC Media Player" "vlc" install_vlc
check_and_ask "OBS Studio" "obs" install_obs
check_and_ask "Audacity" "audacity" install_audacity "snap"
check_and_ask "Blender" "blender" install_blender "snap"
check_and_ask "Figma" "figma-linux" install_figma "snap"

echo -e "\n${YELLOW}--- Utilities ---${NC}"
check_and_ask "Flameshot" "flameshot" install_flameshot
check_and_ask "GParted" "gparted" install_gparted
check_and_ask "Btop" "btop" install_btop
check_and_ask "Steam" "steam" install_steam

echo -e "\n${GREEN}All Apps Setup Complete! 🚀${NC}\n"
