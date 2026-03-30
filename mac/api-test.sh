#!/bin/bash
# Author: Bhavin Pathak
# Description: Essential API Testing Tools Setup (macOS)

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

install_postman() {
    if is_installed "Postman" "postman"; then
        echo -e "${GREEN}Postman is already installed.${NC}"
        return
    fi
    print_msg "Installing Postman"
    brew install --cask postman
    echo -e "${GREEN}Postman Installed.${NC}"
}

install_insomnia() {
    if is_installed "Insomnia" "insomnia"; then
        echo -e "${GREEN}Insomnia is already installed.${NC}"
        return
    fi
    print_msg "Installing Insomnia"
    brew install --cask insomnia
    echo -e "${GREEN}Insomnia Installed.${NC}"
}

# --- Main ---

clear
echo -e "${BLUE}${BOLD}API Testing Tools Setup (macOS)${NC}"
echo -e "----------------------"

# Ensure brew is installed
if ! command -v brew &> /dev/null; then
    echo -e "${RED}Homebrew is not installed. Please run terminal.sh first or install it manually.${NC}"
    exit 1
fi

ask_install "Postman" && install_postman
ask_install "Insomnia" && install_insomnia

echo -e "\n${GREEN}API Tools Ready! 🚀${NC}\n"
