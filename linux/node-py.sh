#!/bin/bash
# Author: Bhavin Pathak
# Description: Unified Node.js & Python Development Stack Setup

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
    
    if is_installed "$check_cmd"; then
        echo -e "${GREEN}✔ $name is already installed. Skipped.${NC}"
    else
        if ask_install "$name"; then
            $install_func
        fi
    fi
}

get_shell_rc() {
    if [[ "$SHELL" == *"zsh"* ]]; then
        echo "$HOME/.zshrc"
    elif [[ "$SHELL" == *"bash"* ]]; then
        echo "$HOME/.bashrc"
    else
        echo "$HOME/.bashrc"
    fi
}

# --- Node.js Installers ---

install_nvm_node() {
    print_msg "Updating System"
    sudo apt update && sudo apt install -y curl

    # Install NVM
    if [ ! -d "$HOME/.nvm" ]; then
        print_msg "Installing NVM"
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    else
        echo -e "${GREEN}NVM directory exists.${NC}"
    fi

    # Load NVM
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    # Install Node LTS
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
    
    # Config Shell
    local rc_file=$(get_shell_rc)
    if ! grep -q "corepack enable" "$rc_file"; then
        echo "" >> "$rc_file"
        echo "# Node Corepack" >> "$rc_file"
        echo "corepack enable" >> "$rc_file"
        echo -e "${GREEN}Added 'corepack enable' to $rc_file${NC}"
    fi
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
    
    # Config Shell
    local rc_file=$(get_shell_rc)
    if ! grep -q "BUN_INSTALL" "$rc_file"; then
        echo "" >> "$rc_file"
        echo "# Bun" >> "$rc_file"
        echo 'export BUN_INSTALL="$HOME/.bun"' >> "$rc_file"
        echo 'export PATH=$BUN_INSTALL/bin:$PATH' >> "$rc_file"
        echo -e "${GREEN}Added Bun to PATH in $rc_file${NC}"
    fi
    echo -e "${GREEN}Bun Installed.${NC}"
}

install_nodemon() {
    print_msg "Installing Nodemon (Global)"
    npm install -g nodemon
    echo -e "${GREEN}Nodemon Installed.${NC}"
}

# --- Python Installers ---

install_python_env() {
    print_msg "Installing Python 3, Pip, Venv, Dev Tools"
    sudo apt update
    sudo apt install -y python3 python3-pip python3-venv python3-dev build-essential
    
    print_msg "Setting Alternatives"
    sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 1 || true
    sudo update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1 || true

    # Config Shell
    local rc_file=$(get_shell_rc)
    local user_bin='export PATH=$PATH:~/.local/bin'
    
    if ! grep -q "PATH.*.local/bin" "$rc_file"; then
        echo "" >> "$rc_file"
        echo "# Python Local Bin" >> "$rc_file"
        echo "$user_bin" >> "$rc_file"
        echo -e "${GREEN}Added ~/.local/bin to PATH in $rc_file${NC}"
    fi
    
    echo -e "${GREEN}Python Environment Setup Complete.${NC}"
}

# --- Main ---

clear
echo -e "${BLUE}${BOLD}Node.js & Python Stack Setup${NC}"
echo -e "---------------------------------"

echo -e "\n${YELLOW}--- Node.js Stack ---${NC}"
# Special check for NVM/Node since NVM isn't a simple command
if [ -d "$HOME/.nvm" ] && command -v node &> /dev/null; then
     echo -e "${GREEN}✔ Node.js & NVM are already installed. Skipped.${NC}"
else
    if ask_install "Node.js (LTS) & NVM"; then
        install_nvm_node
    fi
fi

check_and_ask "Yarn" "yarn" install_yarn
check_and_ask "PNPM" "pnpm" install_pnpm
check_and_ask "Bun" "bun" install_bun
check_and_ask "Nodemon" "nodemon" install_nodemon

echo -e "\n${YELLOW}--- Python Stack ---${NC}"
# Check generic python3, but real value is the dev tools/pip/venv. 
# "python3" is almost always there. Let's check "pip3" or "pip" as a proxy for a dev-ready env, or just ask.
# User asked for "already install to nahi hai" check.
if command -v python3 &> /dev/null && command -v pip &> /dev/null && command -v venv &> /dev/null; then 
    echo -e "${GREEN}✔ Python 3, Pip & Venv are presumably set. Skipped.${NC}"
else
     # Since python is usually pre-installed, checking 'pip' is safer for "dev environment ready"
    check_and_ask "Python 3 Dev Env (Pip, Venv, Build Essentials)" "pip" install_python_env
fi

echo -e "\n${GREEN}Stack Setup Complete! 🚀${NC}\n"
