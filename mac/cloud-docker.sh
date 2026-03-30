#!/bin/bash
# Author: Bhavin Pathak
# Description: Docker & Cloud DevOps Tools Installer (macOS)

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

install_brew() {
    local name="$1"
    local brew_name="$2"
    
    if is_installed "$brew_name"; then
        echo -e "${GREEN}✔ $name is already installed. Skipped.${NC}"
        return
    fi
    if ask_install "$name"; then
        print_msg "Installing $name"
        brew install "$brew_name"
        echo -e "${GREEN}$name Installed.${NC}"
    fi
}

install_docker_desktop() {
    if [ -d "/Applications/Docker.app" ]; then
        echo -e "${GREEN}✔ Docker Desktop is already installed. Skipped.${NC}"
        return
    fi
    if ask_install "Docker Desktop"; then
        print_msg "Installing Docker Desktop"
        brew install --cask docker
        echo -e "${GREEN}Docker Desktop Installed.${NC}"
    fi
}

clear
echo -e "${BLUE}${BOLD}Cloud & Containers Setup (macOS)${NC}"
echo -e "---------------------------"

if ! command -v brew &> /dev/null; then
    echo -e "${RED}Homebrew is not installed. Please run terminal.sh first.${NC}"
    exit 1
fi

install_docker_desktop

echo -e "\n${YELLOW}--- Cloud Tools ---${NC}"
install_brew "AWS CLI v2" "awscli"
install_brew "Terraform" "terraform"
install_brew "Kubectl" "kubectl"
install_brew "Ansible" "ansible"
install_brew "Azure CLI" "azure-cli"

echo -e "\n${GREEN}Setup Complete! ☁️${NC}\n"
