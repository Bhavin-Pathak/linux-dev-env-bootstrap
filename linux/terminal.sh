#!/bin/bash
# Author: Bhavin Pathak
# Description: Ultimate Terminal Setup (Zsh + Starship + NerdFonts + Modern Tools)

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
# 1. Install Essentials (Curl, Git, Zip)
# ==========================================
print_msg "Installing Prerequisites"
sudo apt update
sudo apt install -y curl git unzip fontconfig

# ==========================================
# 2. Install Modern CLI Tools
# ==========================================
print_msg "Installing Modern CLI Tools (bat, fzf, btop)"

# Bat (Color Cat)
sudo apt install -y bat fzf btop
# Link batcat to bat if needed
if ! command -v bat &> /dev/null; then
    sudo ln -s /usr/bin/batcat /usr/local/bin/bat || true
fi

# Eza (Better LS) - Needs specific repo
print_msg "Installing Eza (Modern LS)"
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg --yes
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo apt update
sudo apt install -y eza

# ==========================================
# 3. Install Zsh
# ==========================================
print_msg "Installing Zsh Shell"
sudo apt install -y zsh

# Make Zsh default (interactive check to avoid locking out)
if [[ "$SHELL" != *"zsh"* ]]; then
    echo -e "${YELLOW}Changing default shell to Zsh...${NC}"
    chsh -s $(which zsh)
fi

# ==========================================
# 4. Install Oh-My-Zsh & Plugins
# ==========================================
print_msg "Installing Oh-My-Zsh Engine"

# Check if OMZ installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo -e "${GREEN}Oh-My-Zsh already installed.${NC}"
fi

# Plugins (Auto-Suggestions & Syntax Highlighting)
ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}

print_msg "Installing Zsh Plugins"
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
fi

# ==========================================
# 5. Powerlevel10k Theme
# ==========================================
print_msg "Installing Powerlevel10k Theme 🚀"
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
else
    echo -e "${GREEN}Powerlevel10k already installed.${NC}"
fi

# ==========================================
# 6. Nerd Fonts (Hack)
# ==========================================
print_msg "Installing Nerd Fonts"
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

if [ -f "./Hack.zip" ]; then
    echo -e "${GREEN}Found local Hack.zip! Installing...${NC}"
    unzip -o ./Hack.zip -d "$FONT_DIR"
else
    echo -e "${YELLOW}Local Hack.zip not found. Downloading JetBrains Mono...${NC}"
    wget -O /tmp/JetBrainsMono.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
    unzip -o /tmp/JetBrainsMono.zip -d "$FONT_DIR"
    rm /tmp/JetBrainsMono.zip
fi

fc-cache -fv

# ==========================================
# 7. Configure .zshrc
# ==========================================
print_msg "Configuring .zshrc"

# RC_FILE
RC_FILE="$HOME/.zshrc"

# Change Theme to Powerlevel10k
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' "$RC_FILE"

# Add Plugin list
sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/g' "$RC_FILE"

# Add Tool Aliases
if ! grep -q "alias ls='eza" "$RC_FILE"; then
cat <<EOT >> "$RC_FILE"

# --- Modern Tools Updates ---
alias ls='eza --icons --group-directories-first'
alias ll='eza -al --icons --group-directories-first'
alias cat='bat'
alias top='btop'

# To customize prompt, run: p10k configure
EOT
fi

echo -e "\n${GREEN}✨ Terminal Setup Complete! ✨${NC}"
echo -e "${YELLOW}Please restart your terminal or log out/in to see the magic.${NC}\n"
