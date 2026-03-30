#!/bin/bash
# Author: Bhavin Pathak
# Description: Ultimate Terminal Setup (macOS)

set -e

BOLD='\033[1m'
BLUE='\033[1;34m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m'

print_msg() { echo -e "\n${BLUE}${BOLD}>>> $1...${NC}\n"; }

print_msg "Checking Homebrew"
if ! command -v brew &> /dev/null; then
    echo -e "${YELLOW}Installing Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

print_msg "Installing Modern CLI Tools (bat, fzf, eza, btop)"
brew install bat fzf eza btop

print_msg "Installing Oh-My-Zsh Engine"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo -e "${GREEN}Oh-My-Zsh already installed.${NC}"
fi

ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}

print_msg "Installing Zsh Plugins"
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
fi
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
fi

print_msg "Installing Powerlevel10k Theme"
if [ ! -d "${ZSH_CUSTOM}/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM}/themes/powerlevel10k
else
    echo -e "${GREEN}Powerlevel10k already installed.${NC}"
fi

print_msg "Installing Nerd Fonts"
FONT_DIR="$HOME/Library/Fonts"
if [ -f "../Hack.zip" ]; then
    echo -e "${GREEN}Found local Hack.zip! Installing...${NC}"
    unzip -o ../Hack.zip -d "$FONT_DIR"
else
    echo -e "${YELLOW}Local Hack.zip not found. Downloading JetBrains Mono...${NC}"
    wget -O /tmp/JetBrainsMono.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip || curl -L https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip -o /tmp/JetBrainsMono.zip
    unzip -o /tmp/JetBrainsMono.zip -d "$FONT_DIR"
    rm /tmp/JetBrainsMono.zip
fi

print_msg "Configuring .zshrc"
RC_FILE="$HOME/.zshrc"
sed -i '' 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' "$RC_FILE" 2>/dev/null || true
sed -i '' 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/g' "$RC_FILE" 2>/dev/null || true

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
