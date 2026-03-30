#!/bin/bash
# Author: Bhavin Pathak
# Description: Cloudflare WARP Installation & Setup (macOS)

set -e

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
    [ -d "/Applications/Cloudflare WARP.app" ] || command -v warp-cli &> /dev/null
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

install_warp() {
    print_msg "Installing Cloudflare WARP"
    brew install --cask cloudflare-warp
    echo -e "${GREEN}Cloudflare WARP Installed.${NC}"
}

setup_warp() {
    print_msg "Cloudflare WARP Configuration (Requires warp-cli)"
    if ! command -v warp-cli &> /dev/null; then
        echo -e "${YELLOW}warp-cli not found. Please register manually via the Cloudflare WARP App in Applications.${NC}"
        return
    fi
    
    echo -e "${YELLOW}Register New Client? [y/n]${NC}"
    read -p "> " reg_choice
    if [[ "$reg_choice" =~ ^[yY] ]]; then warp-cli register; fi

    echo -e "${YELLOW}Connect Client? [y/n]${NC}"
    read -p "> " conn_choice
    if [[ "$conn_choice" =~ ^[yY] ]]; then warp-cli connect; fi

    echo -e "\n${GREEN}Testing Connection...${NC}"
    curl -s https://www.cloudflare.com/cdn-cgi/trace/ | grep "warp="
}

clear
echo -e "${BLUE}${BOLD}Cloudflare WARP Setup (macOS)${NC}"
echo -e "------------------------"

if is_installed warp-cli; then
    echo -e "${GREEN}✔ Cloudflare WARP is already installed.${NC}"
    echo -e "${YELLOW}Do you want to run setup/config again? [y/n]${NC}"
    read -p "> " config_again
    if [[ "$config_again" =~ ^[yY] ]]; then setup_warp; fi
else
    if ask_install "Cloudflare WARP"; then install_warp; setup_warp; fi
fi

echo -e "\n${GREEN}WARP Setup Complete! 🚀${NC}\n"
