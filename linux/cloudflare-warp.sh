#!/bin/bash
# Author: Bhavin Pathak
# Description: Cloudflare WARP Installation & Setup (VPN + DNS)

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

# --- Installers ---

install_warp() {
    print_msg "Adding Cloudflare GPG Key & Repository"
    
    # Add Cloudflare GPG key
    curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg | sudo gpg --yes --dearmor -o /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg

    # Add Cloudflare Repo
    echo "deb [signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/cloudflare-client.list

    print_msg "Updates & Installing Cloudflare WARP"
    sudo apt-get update && sudo apt-get install cloudflare-warp -y

    echo -e "${GREEN}Cloudflare WARP Installed.${NC}"
}

setup_warp() {
    print_msg "Cloudflare WARP Configuration"
    
    echo -e "${YELLOW}Register New Client? [y/n]${NC}"
    read -p "> " reg_choice
    if [[ "$reg_choice" =~ ^[yY] ]]; then
        warp-cli registration new
    fi

    echo -e "${YELLOW}Connect Client? [y/n]${NC}"
    read -p "> " conn_choice
    if [[ "$conn_choice" =~ ^[yY] ]]; then
        warp-cli connect
    fi

    echo -e "${YELLOW}Set Mode (1=WARP+DoH, 2=DoH Only, 0=Skip)?${NC}"
    read -p "> " mode_choice
    case "$mode_choice" in
        1) warp-cli mode warp+doh ;;
        2) warp-cli mode doh ;;
        *) echo "Skipping mode setup." ;;
    esac

    echo -e "\n${GREEN}Testing Connection...${NC}"
    curl https://www.cloudflare.com/cdn-cgi/trace/
}

uninstall_warp() {
    print_msg "Uninstalling Cloudflare WARP"
    sudo apt-get remove --purge cloudflare-warp -y
    sudo rm /etc/apt/sources.list.d/cloudflare-client.list
    sudo rm /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg
    echo -e "${GREEN}Cloudflare WARP Uninstalled.${NC}"
}


# --- Main ---

clear
echo -e "${BLUE}${BOLD}Cloudflare WARP Setup${NC}"
echo -e "------------------------"

if is_installed warp-cli; then
    echo -e "${GREEN}✔ Cloudflare WARP is already installed.${NC}"
    echo -e "${YELLOW}Do you want to run setup/config again? [y/n]${NC}"
    read -p "> " config_again
    if [[ "$config_again" =~ ^[yY] ]]; then
        setup_warp
    fi
else
    if ask_install "Cloudflare WARP"; then
        install_warp
        setup_warp
    fi
fi

echo -e "\n${GREEN}WARP Setup Complete! 🚀${NC}\n"
