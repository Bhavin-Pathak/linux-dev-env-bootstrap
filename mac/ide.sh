#!/bin/bash
# Author: Bhavin Pathak
# Description: Modern IDEs & Editors Installer (macOS)

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

clear
echo -e "${BLUE}${BOLD}IDE & Editor Setup (macOS)${NC}"
echo -e "------------------------"

install_cask "VS Code" "visual-studio-code" "Visual Studio Code"
install_cask "Cursor IDE" "cursor" "Cursor"
install_cask "Windsurf IDE" "windsurf" "Windsurf"
install_cask "Sublime Text" "sublime-text" "Sublime Text"
install_cask "Antigravity IDE" "antigravity" "Antigravity" || echo -e "${YELLOW}Antigravity might not be available in Homebrew. Please install manually if it fails.${NC}"

echo -e "\n${GREEN}IDE Setup Complete! 💻${NC}\n"
