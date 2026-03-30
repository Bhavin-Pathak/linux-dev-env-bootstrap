#!/bin/bash
# Author: Bhavin Pathak
# Description: Modern IDEs & Editors Installer

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

install_vscode() {
    print_msg "Installing VS Code"
    sudo snap install code --classic
    echo -e "${GREEN}VS Code Installed.${NC}"
}

install_cursor() {
    print_msg "Installing Cursor AI Editor"
    
    # Downloading specific .deb version (v2.4.37)
    wget -O cursor.deb "https://downloads.cursor.com/production/7b9c34466f5c119e93c3e654bb80fe9306b6cc79/linux/x64/deb/amd64/deb/cursor_2.4.37_amd64.deb"
    
    sudo apt install ./cursor.deb -y
    rm cursor.deb
    echo -e "${GREEN}Cursor Installed.${NC}"
}

install_windsurf() {
    print_msg "Installing Windsurf IDE"

    # Official Repo Setup
    sudo apt-get install -y wget gpg apt-transport-https
    
    wget -qO- "https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/windsurf.gpg" | gpg --dearmor > windsurf-stable.gpg
    sudo install -D -o root -g root -m 644 windsurf-stable.gpg /etc/apt/keyrings/windsurf-stable.gpg
    
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/windsurf-stable.gpg] https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/apt stable main" | sudo tee /etc/apt/sources.list.d/windsurf.list > /dev/null
    
    rm -f windsurf-stable.gpg
    
    sudo apt update
    sudo apt install windsurf -y
    echo -e "${GREEN}Windsurf IDE OK.${NC}"
}

install_sublime() {
    print_msg "Installing Sublime Text"
    sudo snap install sublime-text --classic
    echo -e "${GREEN}Sublime Text Installed.${NC}"
}

install_notepadpp() {
    print_msg "Installing Notepad++ (Snap)"
    if ! is_installed snap; then sudo apt install snapd -y; fi
    sudo snap install notepad-plus-plus
    echo -e "${GREEN}Notepad++ Installed.${NC}"
}


install_antigravity() {
    print_msg "Installing Antigravity IDE"

    # Create keyrings directory if not exists
    sudo mkdir -p /etc/apt/keyrings

    # Add GPG Key
    curl -fsSL https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg | \
      sudo gpg --dearmor --yes -o /etc/apt/keyrings/antigravity-repo-key.gpg

    # Add Repository
    echo "deb [signed-by=/etc/apt/keyrings/antigravity-repo-key.gpg] https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/ antigravity-debian main" | \
      sudo tee /etc/apt/sources.list.d/antigravity.list > /dev/null

    # Install
    sudo apt update
    sudo apt install antigravity -y
    
    echo -e "${GREEN}Antigravity IDE Installed.${NC}"
}

# --- Main ---

clear
echo -e "${BLUE}${BOLD}IDE & Editor Setup${NC}"
echo -e "------------------------"

# Ensure Snap is ready for VSCode/Sublime/Notepad++
if ! is_installed snap; then 
    echo -e "${YELLOW}Installing Snapd (Required for VSCode, Sublime, Notepad++)${NC}"
    sudo apt update && sudo apt install snapd -y
fi

check_and_ask "VS Code" "code" install_vscode "snap"
check_and_ask "Cursor IDE" "cursor" install_cursor 
check_and_ask "Windsurf IDE" "windsurf" install_windsurf
check_and_ask "Sublime Text" "sublime-text" install_sublime "snap"
check_and_ask "Notepad++" "notepad-plus-plus" install_notepadpp "snap"
check_and_ask "Antigravity IDE" "antigravity" install_antigravity

echo -e "\n${GREEN}IDE Setup Complete! 💻${NC}\n"
