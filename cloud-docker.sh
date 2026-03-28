#!/bin/bash
# Author: Bhavin Pathak
# Description: Docker & Cloud DevOps Tools Installer

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

    local already_installed=false

    if [ "$check_type" == "dpkg" ]; then
        if dpkg -l | grep -q "$check_cmd"; then already_installed=true; fi
    elif [ "$check_type" == "snap" ]; then
        if snap list 2>/dev/null | grep -q "$check_cmd"; then already_installed=true; fi
    else 
        if is_installed "$check_cmd"; then already_installed=true; fi
    fi

    if [ "$already_installed" = true ]; then
        echo -e "${GREEN}✔ $name is already installed. Skipped.${NC}"
    else
        if ask_install "$name"; then
            $install_func
        fi
    fi
}

# --- Installers ---

install_docker_desktop() {
    print_msg "Installing Docker Desktop"
    wget -O docker-desktop.deb "https://desktop.docker.com/linux/main/amd64/docker-desktop-4.27.0-amd64.deb"
    sudo apt-get update
    sudo apt-get install ./docker-desktop.deb -y
    rm docker-desktop.deb

    # Enable and start Docker Desktop service
    systemctl --user enable --now docker-desktop
    
    echo -e "${GREEN}Docker Desktop Installed and background service started.${NC}"
}

install_docker_engine() {
    print_msg "Installing Docker Engine"
    # Remove old versions
    for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

    # Add repo
    sudo apt-get update
    sudo apt-get install -y ca-certificates curl gnupg
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    echo \
      "deb [arch=\"$(dpkg --print-architecture)\" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # Enable and start Docker services to run in background
    sudo systemctl enable --now docker.service
    sudo systemctl enable --now containerd.service

    # User Group
    sudo usermod -aG docker $USER
    echo -e "${GREEN}Docker Engine Installed and background service started. Please re-login for group changes to take effect.${NC}"
}

install_aws_cli() {
    print_msg "Installing AWS CLI"
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip -q awscliv2.zip
    sudo ./aws/install --update
    rm -rf aws awscliv2.zip
    echo -e "${GREEN}AWS CLI Installed.${NC}"
}

install_terraform() {
    print_msg "Installing Terraform"
    sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
    wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update
    sudo apt install -y terraform
    echo -e "${GREEN}Terraform Installed.${NC}"
}

install_kubectl() {
    print_msg "Installing Kubectl"
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg --yes
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo apt-get update
    sudo apt-get install -y kubectl
    echo -e "${GREEN}Kubectl Installed.${NC}"
}

install_ansible() {
    print_msg "Installing Ansible"
    sudo add-apt-repository --yes --update ppa:ansible/ansible
    sudo apt install -y ansible
    echo -e "${GREEN}Ansible Installed.${NC}"
}

install_azure_cli() {
    print_msg "Installing Azure CLI"
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
    echo -e "${GREEN}Azure CLI Installed.${NC}"
}

# --- Main ---

clear
echo -e "${BLUE}${BOLD}Cloud & Containers Setup${NC}"
echo -e "---------------------------"

# Docker Selection
echo -e "${YELLOW}Choose your Docker flavor:${NC}"
echo "1. Docker Desktop (GUI + Engine) [Recommended for Beginners]"
echo "2. Docker Engine (CLI Only) [Lightweight]"
echo "3. Skip Docker"
read -p "> " dockchoice

case $dockchoice in
    1) check_and_ask "Docker Desktop" "docker-desktop" install_docker_desktop "dpkg" ;;
    2) check_and_ask "Docker Engine" "docker" install_docker_engine ;;
    *) echo "Skipping Docker." ;;
esac

echo -e "\n${YELLOW}--- Cloud Tools ---${NC}"
check_and_ask "AWS CLI v2" "aws" install_aws_cli
check_and_ask "Terraform" "terraform" install_terraform
check_and_ask "Kubectl" "kubectl" install_kubectl
check_and_ask "Ansible" "ansible" install_ansible
check_and_ask "Azure CLI" "az" install_azure_cli

echo -e "\n${GREEN}Setup Complete! ☁️${NC}\n"
