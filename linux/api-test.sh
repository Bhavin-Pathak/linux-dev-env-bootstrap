#!/bin/bash
# Author: Bhavin Pathak
# Description: Essential API Testing Tools Setup

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

setup_snap() {
    if ! is_installed snap; then
        print_msg "Installing Snapd"
        sudo apt update && sudo apt install snapd -y
    fi
}

install_postman() {
    if is_installed postman; then
        echo -e "${GREEN}Postman is already installed.${NC}"
        return
    fi
    print_msg "Installing Postman"
    sudo snap install postman
    echo -e "${GREEN}Postman Installed.${NC}"
}

install_insomnia() {
    if is_installed insomnia; then
        echo -e "${GREEN}Insomnia is already installed.${NC}"
        return
    fi
    print_msg "Installing Insomnia"
    sudo snap install insomnia
    echo -e "${GREEN}Insomnia Installed.${NC}"
}

# --- Main ---

clear
echo -e "${BLUE}${BOLD}API Testing Tools Setup${NC}"
echo -e "----------------------"

setup_snap

ask_install "Postman" && install_postman
ask_install "Insomnia" && install_insomnia

echo -e "\n${GREEN}API Tools Ready! 🚀${NC}\n"
