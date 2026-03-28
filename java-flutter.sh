#!/bin/bash
# Author: Bhavin Pathak
# Description: Flutter, Dart, & Android Studio Setup with Smart Path Config

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
    local check_type="${4:-command}"

    if is_installed "$check_cmd"; then
        echo -e "${GREEN}✔ $name is already installed. Skipped.${NC}"
    else
        if ask_install "$name"; then
            $install_func
        fi
    fi
}

# --- Installers ---

install_java() {
    if is_installed java; then
        echo -e "${GREEN}Java is already installed: $(java -version 2>&1 | head -n 1)${NC}"
        # Still check path config
        configure_java_path
        return
    fi

    print_msg "Updating Package List"
    sudo apt update

    print_msg "Installing OpenJDK 17"
    sudo apt install -y openjdk-17-jdk
    echo -e "${GREEN}Java Installed.${NC}"

    configure_java_path
}

configure_java_path() {
    # Detect Shell
    local shell_config=""
    if [[ "$SHELL" == *"zsh"* ]]; then
        shell_config="$HOME/.zshrc"
    elif [[ "$SHELL" == *"bash"* ]]; then
        shell_config="$HOME/.bashrc"
    else
        shell_config="$HOME/.bashrc"
    fi

    local java_path="/usr/lib/jvm/java-17-openjdk-amd64"

    # Check and Append
    if grep -q "JAVA_HOME.*$java_path" "$shell_config"; then
        echo -e "${GREEN}JAVA_HOME already set in $shell_config${NC}"
    else
        echo "" >> "$shell_config"
        echo "export JAVA_HOME=$java_path" >> "$shell_config"
        echo 'export PATH=$JAVA_HOME/bin:$PATH' >> "$shell_config"
        echo -e "${GREEN}Added JAVA_HOME to $shell_config${NC}"
    fi
}

setup_snap() {
    if ! is_installed snap; then
        print_msg "Installing Snapd"
        sudo apt update && sudo apt install snapd -y
    fi
}

install_flutter() {
    print_msg "Installing Flutter Version Management (FVM)"
    
    if ! is_installed fvm && [ ! -f "$HOME/fvm/bin/fvm" ]; then
        curl -fsSL https://fvm.app/install.sh | bash
        echo -e "${GREEN}FVM Installed.${NC}"
    else
        echo -e "${GREEN}FVM is already installed.${NC}"
    fi

    local fvm_cmd="fvm"
    if [ -f "$HOME/fvm/bin/fvm" ]; then
        fvm_cmd="$HOME/fvm/bin/fvm"
    fi

    print_msg "Installing Flutter (Stable) via FVM"
    $fvm_cmd install stable
    $fvm_cmd global stable
    echo -e "${GREEN}Flutter SDK (Stable) Installed and set as Global.${NC}"
    
    configure_path
}

configure_path() {
    # Detect Shell
    local shell_config=""
    if [[ "$SHELL" == *"zsh"* ]]; then
        shell_config="$HOME/.zshrc"
        print_msg "Detected Zsh. Configuring $shell_config"
    elif [[ "$SHELL" == *"bash"* ]]; then
        shell_config="$HOME/.bashrc"
        print_msg "Detected Bash. Configuring $shell_config"
    else
        # Fallback or ask? Default to bashrc if unsure
        shell_config="$HOME/.bashrc"
        echo -e "${YELLOW}Unknown shell ($SHELL). Defaulting to $shell_config${NC}"
    fi

    # Check and Append
    if grep -q "fvm/default/bin" "$shell_config"; then
        echo -e "${GREEN}Path already configured in $shell_config${NC}"
    else
        echo 'export PATH=$HOME/fvm/bin:$PATH' >> "$shell_config"
        echo 'export PATH=$HOME/fvm/default/bin:$PATH' >> "$shell_config"
        echo 'export PATH=$HOME/fvm/default/bin/cache/dart-sdk/bin:$PATH' >> "$shell_config"
        echo -e "${GREEN}Added FVM and Flutter/Dart to PATH in $shell_config${NC}"
        echo -e "${YELLOW}Run 'source $shell_config' or restart terminal to apply.${NC}"
    fi
}

install_android_studio() {
    if is_installed android-studio; then
        echo -e "${GREEN}Android Studio is already installed.${NC}"
        return
    fi
    print_msg "Installing Android Studio"
    sudo snap install android-studio --classic
    echo -e "${GREEN}Android Studio Installed.${NC}"
}

# --- Main ---

clear
echo -e "${BLUE}${BOLD}Flutter & Mobile Dev Setup${NC}"
echo -e "---------------------------"

setup_snap

check_and_ask "Java (OpenJDK 17)" "java" install_java
check_and_ask "Flutter (via FVM)" "fvm" install_flutter
check_and_ask "Android Studio" "android-studio" install_android_studio

echo -e "\n${GREEN}Setup Complete! 📱${NC}"
echo -e "${YELLOW}Don't forget to run 'flutter doctor' after restarting your terminal.${NC}\n"
