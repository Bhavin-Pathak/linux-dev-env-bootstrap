#!/bin/bash
# Author: Bhavin Pathak
# Description: Unified Node.js & Python Development Stack Setup (macOS)

set -e

BOLD='\033[1m'
BLUE='\033[1;34m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m'

print_msg() { echo -e "\n${BLUE}${BOLD}>>> $1...${NC}\n"; }

is_installed() { command -v "$1" &> /dev/null; }

ask_install() {
    local name=$1
    echo -e "${YELLOW}Install ${BOLD}$name${NC}${YELLOW}? [y/n]${NC}"
    read -p "> " choice
    case "$choice" in 
        [yY]*) return 0 ;;
        *) echo -e "${RED}Skipped $name.${NC}"; return 1 ;;
    esac
}

get_shell_rc() {
    if [[ "$SHELL" == *"bash"* ]]; then echo "$HOME/.bashrc"; else echo "$HOME/.zshrc"; fi
}

install_nvm_node() {
    print_msg "Installing NVM"
    if [ ! -d "$HOME/.nvm" ]; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    else
        echo -e "${GREEN}NVM directory exists.${NC}"
    fi

    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    print_msg "Installing Node.js LTS"
    nvm install --lts
    nvm use --lts
    nvm alias default 'lts/*'
    echo -e "${GREEN}Node.js $(node -v) & NPM $(npm -v) Installed.${NC}"
}

install_yarn() {
    print_msg "Enabling Corepack & Installing Yarn"
    corepack enable
    corepack prepare yarn@stable --activate
    echo -e "${GREEN}Yarn Installed.${NC}"
}

install_pnpm() {
    print_msg "Installing PNPM via Corepack"
    corepack enable
    corepack prepare pnpm@latest --activate
    echo -e "${GREEN}PNPM Installed.${NC}"
}

install_bun() {
    print_msg "Installing Bun"
    curl -fsSL https://bun.sh/install | bash
    echo -e "${GREEN}Bun Installed.${NC}"
}

install_nodemon() {
    print_msg "Installing Nodemon (Global)"
    npm install -g nodemon
    echo -e "${GREEN}Nodemon Installed.${NC}"
}

install_python_env() {
    print_msg "Installing Python 3"
    brew install python3
    
    local rc_file=$(get_shell_rc)
    if ! grep -q "PATH.*.local/bin" "$rc_file"; then
        echo "" >> "$rc_file"
        echo 'export PATH=$PATH:~/.local/bin' >> "$rc_file"
        echo -e "${GREEN}Added ~/.local/bin to PATH in $rc_file${NC}"
    fi
    echo -e "${GREEN}Python Environment Setup Complete.${NC}"
}

clear
echo -e "${BLUE}${BOLD}Node.js & Python Stack Setup (macOS)${NC}"
echo -e "---------------------------------"

echo -e "\n${YELLOW}--- Node.js Stack ---${NC}"
if [ -d "$HOME/.nvm" ] && command -v node &> /dev/null; then
     echo -e "${GREEN}✔ Node.js & NVM are already installed. Skipped.${NC}"
else
    if ask_install "Node.js (LTS) & NVM"; then install_nvm_node; fi
fi

if ask_install "Yarn"; then install_yarn; fi
if ask_install "PNPM"; then install_pnpm; fi
if ask_install "Bun"; then install_bun; fi
if ask_install "Nodemon"; then install_nodemon; fi

echo -e "\n${YELLOW}--- Python Stack ---${NC}"
if is_installed python3 && is_installed pip3; then
    echo -e "${GREEN}✔ Python 3 is already installed. Skipped.${NC}"
else
    if ask_install "Python 3 Dev Env"; then install_python_env; fi
fi

echo -e "\n${GREEN}Stack Setup Complete! 🚀${NC}\n"
