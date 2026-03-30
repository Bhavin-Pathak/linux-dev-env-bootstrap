#!/bin/bash
# Author: Bhavin Pathak
# Description: Flutter, Dart, & Android Studio Setup (macOS)

set -e

BOLD='\033[1m'
BLUE='\033[1;34m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m'

print_msg() { echo -e "\n${BLUE}${BOLD}>>> $1...${NC}\n"; }

is_installed() { command -v "$1" &> /dev/null; }
is_app_installed() { [ -d "/Applications/$1.app" ]; }

ask_install() {
    local name=$1
    echo -e "${YELLOW}Install ${BOLD}$name${NC}${YELLOW}? [y/n]${NC}"
    read -p "> " choice
    case "$choice" in 
        [yY]*) return 0 ;;
        *) echo -e "${RED}Skipped $name.${NC}"; return 1 ;;
    esac
}

configure_java_path() {
    local shell_config="$HOME/.zshrc"
    if [[ "$SHELL" == *"bash"* ]]; then shell_config="$HOME/.bashrc"; fi

    if grep -q "CPPFLAGS.*openjdk" "$shell_config"; then
        echo -e "${GREEN}Java Path already configured in $shell_config${NC}"
    else
        echo 'export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"' >> "$shell_config"
        echo 'export CPPFLAGS="-I/opt/homebrew/opt/openjdk@17/include"' >> "$shell_config"
        echo -e "${GREEN}Added openjdk@17 to $shell_config${NC}"
    fi
}

install_java() {
    if is_installed java; then
        echo -e "${GREEN}Java is already installed: $(java -version 2>&1 | head -n 1)${NC}"
        configure_java_path
        return
    fi
    if ask_install "Java (OpenJDK 17)"; then
        print_msg "Installing OpenJDK 17"
        brew install openjdk@17
        sudo ln -sfn /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17.jdk
        configure_java_path
        echo -e "${GREEN}Java Installed.${NC}"
    fi
}

configure_flutter_path() {
    local shell_config="$HOME/.zshrc"
    if [[ "$SHELL" == *"bash"* ]]; then shell_config="$HOME/.bashrc"; fi

    if grep -q "fvm/default/bin" "$shell_config"; then
        echo -e "${GREEN}FVM Path already configured in $shell_config${NC}"
    else
        echo 'export PATH=$HOME/fvm/default/bin:$PATH' >> "$shell_config"
        echo 'export PATH=$HOME/fvm/default/bin/cache/dart-sdk/bin:$PATH' >> "$shell_config"
        echo -e "${GREEN}Added FVM/Flutter to $shell_config${NC}"
    fi
}

install_flutter() {
    if is_installed fvm; then
        echo -e "${GREEN}FVM is already installed.${NC}"
        configure_flutter_path
        return
    fi
    if ask_install "Flutter (via FVM)"; then
        print_msg "Installing FVM"
        brew tap leoafarias/fvm
        brew install fvm
        fvm install stable
        fvm global stable
        configure_flutter_path
        echo -e "${GREEN}Flutter SDK (Stable) Installed and set as Global.${NC}"
    fi
}

install_android_studio() {
    if is_app_installed "Android Studio"; then
        echo -e "${GREEN}Android Studio is already installed.${NC}"
        return
    fi
    if ask_install "Android Studio"; then
        print_msg "Installing Android Studio"
        brew install --cask android-studio
        echo -e "${GREEN}Android Studio Installed.${NC}"
    fi
}

clear
echo -e "${BLUE}${BOLD}Flutter & Mobile Dev Setup (macOS)${NC}"
echo -e "---------------------------"

install_java
install_flutter
install_android_studio

echo -e "\n${GREEN}Setup Complete! 📱${NC}"
echo -e "${YELLOW}Don't forget to run 'flutter doctor' after restarting your terminal.${NC}\n"
