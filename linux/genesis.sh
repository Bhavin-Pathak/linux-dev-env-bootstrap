#!/bin/bash
# Author: Bhavin Pathak
# Description: Genesis Script - The Origin of Your Dev Environment

# Styling
BOLD='\033[1m'
BLUE='\033[1;34m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m'

# Ensure scripts are executable
chmod +x *.sh

show_menu() {
    clear
    echo -e "${BLUE}${BOLD}🐧 Linux Dev Env Bootstrap${NC}"
    echo -e "${BLUE}https://github.com/Bhavin-Pathak/dev-env-bootstrap${NC}"
    echo -e "--------------------------------------------------------"
    echo -e "Transform your fresh OS into a God-tier Dev Machine."
    echo -e "--------------------------------------------------------"
    echo -e "${YELLOW}1.${NC}  Terminal Setup (Zsh, Hack Fonts, P10k, Bat, Eza, FZF, Btop) 🎨"
    echo -e "${YELLOW}2.${NC}  Modern IDEs (VS Code, Cursor, Windsurf, Sublime, Notepad++) 💻"
    echo -e "${YELLOW}3.${NC}  Web Browsers (Chrome, Brave, Firefox, Edge, Vivaldi, Tor) 🌐"
    echo -e "${YELLOW}4.${NC}  Node & Python Stack (NVM, Yarn, Bun, Pip, Venv) 🚀"
    echo -e "${YELLOW}5.${NC}  Mobile Development (Java 17, Flutter SDK, Android Studio) 📱"
    echo -e "${YELLOW}6.${NC}  DevOps & Cloud (Docker, AWS, Terraform, K8s, Ansible) 🐳"
    echo -e "${YELLOW}7.${NC}  Database Suite (Mongo, Postgres, Redis, Milvus, DBeaver) 🗄️"
    echo -e "${YELLOW}8.${NC}  API Testing Tools (Postman, Insomnia) 🔌"
    echo -e "${YELLOW}9.${NC}  Essential Apps (Slack, Discord, Spotify, VLC, OBS, Steam) 🛠️"
    echo -e "${YELLOW}10.${NC} System Maintenance (Logs, Cache, Trash, Docker Prune) 🧹"
    echo -e "${YELLOW}11.${NC} Cloudflare WARP (VPN & DNS) 🛡️"
    echo -e "--------------------------------------------------------"
    echo -e "${RED}0. Exit${NC}"
    echo -e "--------------------------------------------------------"
}

while true; do
    show_menu
    read -p "Enter your choice: " choice
    
    case $choice in
        1) ./terminal.sh ;;
        2) ./ide.sh ;;
        3) ./browsers.sh ;;
        4) ./node-py.sh ;;
        5) ./java-flutter.sh ;;
        6) ./cloud-docker.sh ;;
        7) ./db-tools.sh ;;
        8) ./api-test.sh ;;
        9) ./essentials.sh ;;
        10) ./cleaner.sh ;;
        11) ./cloudflare-warp.sh ;;
        0) echo -e "\n${GREEN}Happy Coding! 🚀${NC}"; exit 0 ;;
        *) echo -e "\n${RED}Invalid option. Please try again.${NC}"; sleep 1 ;;
    esac
    
    echo -e "\n${BLUE}Press Enter to return to menu...${NC}"
    read
done
