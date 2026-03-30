#!/bin/bash
# Author: Bhavin Pathak
# Description: Safe System Cleanup & Maintenance Tool (macOS)

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

clear
echo -e "${BLUE}${BOLD}System Cleanup Tool (macOS)${NC}"
echo -e "-------------------"
echo -e "${YELLOW}⚠️  This will remove unused caches, temp files, and Docker items.${NC}"
echo -e "${YELLOW}⚠️  Your projects and personal data are SAFE.${NC}\n"

read -p "Start cleanup? (y/N): " choice
if [[ "$choice" != "y" && "$choice" != "Y" ]]; then
    echo -e "${RED}Aborted.${NC}"
    exit 0
fi

print_msg "Cleaning Homebrew Cache"
brew cleanup

print_msg "Cleaning App & System Caches"
rm -rf ~/Library/Caches/Google/Chrome/* 2>/dev/null || true
rm -rf ~/Library/Caches/BraveSoftware/Brave-Browser/* 2>/dev/null || true
rm -rf ~/Library/Caches/Firefox/Profiles/* 2>/dev/null || true

print_msg "Cleaning Development Caches"
# Python
find ~ -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
rm -rf ~/Library/Caches/pip 2>/dev/null || true

# Node
rm -rf ~/.npm 2>/dev/null || true
rm -rf ~/.yarn/cache 2>/dev/null || true
rm -rf ~/Library/pnpm/store 2>/dev/null || true

print_msg "Emptying User Trash"
rm -rf ~/.Trash/* 2>/dev/null || true

print_msg "Checking Docker Environment"
if command -v docker &> /dev/null; then
    if docker info &> /dev/null; then
        echo -e "${YELLOW}Pruning Docker (unused images, networks)...${NC}"
        docker system prune -f
        echo -e "${GREEN}✔ Docker cleanup completed${NC}"
    else
        echo -e "${YELLOW}⚠️ Docker is not running. Skipped Docker cleanup.${NC}"
    fi
fi

echo -e "\n${GREEN}✨ System Cleaned Successfully! ✨${NC}"
df -h / | grep /
echo -e "\n"
