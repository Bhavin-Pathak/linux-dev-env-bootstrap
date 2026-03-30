#!/bin/bash
# Author: Bhavin Pathak
# Description: Complete Database Stack (Servers + GUIs) (macOS)

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

install_brew() {
    local name="$1"
    local tap="$2"
    local brew_name="$3"
    local check_name="$4"
    local check_cmd="$5"

    if is_installed "$check_name" "$check_cmd"; then
        echo -e "${GREEN}✔ $name is already installed. Skipped.${NC}"
        return
    }
    if ask_install "$name"; then
        print_msg "Installing $name"
        if [ ! -z "$tap" ]; then brew tap "$tap"; fi
        brew install "$brew_name"
        echo -e "${GREEN}$name Installed.${NC}"
    fi
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
echo -e "${BLUE}${BOLD}Database Tools & Servers (macOS)${NC}"
echo -e "------------------------"

echo -e "\n${YELLOW}--- PostgreSQL Stack ---${NC}"
install_brew "PostgreSQL Server" "" "postgresql@14" "" "psql"
install_cask "pgAdmin4 (GUI)" "pgadmin4" "pgAdmin 4"

echo -e "\n${YELLOW}--- MongoDB Stack ---${NC}"
install_brew "MongoDB Server" "mongodb/brew" "mongodb-community@8.0" "" "mongod"
install_cask "MongoDB Compass (GUI)" "mongodb-compass" "MongoDB Compass"

echo -e "\n${YELLOW}--- Redis Stack ---${NC}"
install_brew "Redis Server" "" "redis" "" "redis-server"
install_cask "RedisInsight (Racompass Alternative)" "redisinsight" "RedisInsight"

echo -e "\n${YELLOW}--- Milvus Stack ---${NC}"
install_brew "Milvus (Vector DB)" "milvus-io/milvus" "milvus" "" "milvus"
install_cask "Attu (GUI)" "attu" "Attu"

echo -e "\n${YELLOW}--- Universal Tools ---${NC}"
install_cask "DBeaver" "dbeaver-community" "DBeaver"
install_cask "Beekeeper Studio" "beekeeper-studio" "Beekeeper Studio"

echo -e "\n${GREEN}DB Tools Setup Complete! 🗄️${NC}\n"
