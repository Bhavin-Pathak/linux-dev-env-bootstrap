#!/bin/bash
# Author: Bhavin Pathak
# Description: Safe System Cleanup & Maintenance Tool

set -e

# ==========================================
# Styling & Colors
# ==========================================
BOLD='\033[1m'
BLUE='\033[1;34m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m'

print_msg() {
    echo -e "\n${BLUE}${BOLD}>>> $1...${NC}\n"
}

# ==========================================
# Initial Checks & Confirmation
# ==========================================

clear
echo -e "${BLUE}${BOLD}System Cleanup Tool${NC}"
echo -e "-------------------"
echo -e "${YELLOW}⚠️  This will remove unused caches, temp files, and Docker items.${NC}"
echo -e "${YELLOW}⚠️  Your projects and personal data are SAFE.${NC}\n"

read -p "Start cleanup? (y/N): " choice
if [[ "$choice" != "y" && "$choice" != "Y" ]]; then
    echo -e "${RED}Aborted.${NC}"
    exit 0
fi

# Request Sudo upfront
sudo -v

# ==========================================
# 1. System Package Cleanup (APT)
# ==========================================
print_msg "Cleaning APT (System Packages)"
sudo apt update -y
sudo apt full-upgrade -y
sudo apt autoremove -y
sudo apt autoclean -y
sudo apt clean
rm -rf ~/.cache/*

# ==========================================
# 2. System Logs (Journal)
# ==========================================
print_msg "Vacuuming System Logs (>3 days)"
# Keeps only the last 3 days of logs to save space
sudo journalctl --vacuum-time=3d

# ==========================================
# 3. Snap Package Cache
# ==========================================
print_msg "Cleaning Snap Cache"
# Remove disabled (old version) snaps
snap list --all | awk '/disabled/{print $1, $3}' | while read s r; do
    sudo snap remove "$s" --revision="$r"
done
rm -rf ~/snap/*/*/.cache
sudo rm -rf /var/lib/snapd/cache/*
# Clean up leftover Snap trash
rm -rf ~/snap/*/*/.local/share/Trash/files/*

# ==========================================
# 4. Application Caches
# ==========================================
print_msg "Cleaning App Caches (Browsers, IDEs, Thumbnails)"

# Browsers
rm -rf ~/.cache/google-chrome \
       ~/.cache/chromium \
       ~/.cache/BraveSoftware \
       ~/.cache/mozilla/firefox/*/cache2 \
       ~/.cache/thumbnails/* 

# IDEs (VS Code, Cursor, Windsurf, Android Studio)
rm -rf ~/.cache/Google/AndroidStudio* \
       ~/.AndroidStudio*/system/{caches,log,tmp} \
       ~/.config/Code/{Cache,CachedData,GPUCache} \
       ~/.config/Cursor/{Cache,CachedData,GPUCache} \
       ~/.config/Windsurf/{Cache,CachedData,GPUCache} \
       ~/.cache/{Cursor,Windsurf,antigravity} \
       ~/.config/antigravity/{Cache,logs}

# ==========================================
# 5. Language Specific Caches (Python, Node)
# ==========================================
print_msg "Cleaning Development Caches"

# Python
find ~ -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null
rm -rf ~/.cache/pip

# Node / JS
rm -rf ~/.npm \
       ~/.cache/{npm,node-gyp,yarn,bun} \
       ~/.yarn/cache \
       ~/.pnpm-store \
       ~/.local/share/pnpm/store \
       ~/.bun/install/cache

# ==========================================
# 6. User Trash
# ==========================================
print_msg "Emptying User Trash"
rm -rf ~/.local/share/Trash/*

# ==========================================
# 7. Docker Environment
# ==========================================
print_msg "Checking Docker Environment"

if command -v docker &> /dev/null; then
  # Try to start docker if not running
  if ! docker info &> /dev/null; then
    if command -v docker-desktop &> /dev/null || [ -d "$HOME/.docker/desktop" ]; then
      systemctl --user start docker-desktop || true
      sleep 5
    else
      sudo systemctl start docker 2>/dev/null || sudo service docker start 2>/dev/null || true
      sleep 3
    fi
  fi

  if docker info &> /dev/null; then
    echo -e "${YELLOW}Pruning Docker (unused images, containers, networks)...${NC}"
    # Prune everything not currently used
    docker system prune -f
    # Optional: aggressive prune (commented out for safety, uncomment if desired)
    # docker system prune -af --volumes
    echo -e "${GREEN}✔ Docker cleanup completed${NC}"
  else
    echo -e "${YELLOW}⚠️ Docker daemon is not running. Skipped Docker cleanup.${NC}"
  fi
else
  echo -e "${YELLOW}⚠️ Docker is not installed. Skipped Docker cleanup.${NC}"
fi

# ==========================================
# 8. Temporary Files
# ==========================================
print_msg "Cleaning Temp Files"
sudo rm -rf /tmp/* /var/tmp/* 2>/dev/null || true

# ==========================================
# Completion
# ==========================================
echo -e "\n${GREEN}✨ System Cleaned Successfully! ✨${NC}"
df -h / | grep /
echo -e "\n"
