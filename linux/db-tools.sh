#!/bin/bash
# Author: Bhavin Pathak
# Description: Complete Database Stack (Servers + GUIs)
# Installs: Postgres, MongoDB, Redis, Milvus + Their Viewers

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

# Wrapper to check existence before asking
check_and_ask() {
    local name="$1"
    local check_cmd="$2"
    local install_func="$3"
    local check_type="${4:-command}" # command or dpkg

    local already_installed=false

    if [ "$check_type" == "dpkg" ]; then
        if dpkg -l | grep -q "$check_cmd"; then
            already_installed=true
        fi
    else
        if is_installed "$check_cmd"; then
            already_installed=true
        fi
    fi

    if [ "$already_installed" = true ]; then
        echo -e "${GREEN}✔ $name is already installed. Skipped.${NC}"
    else
        # Not installed, so ask user
        if ask_install "$name"; then
            $install_func
        fi
    fi
}

# --- Helpers ---

setup_snap() {
    if ! is_installed snap; then
        print_msg "Installing Snapd"
        sudo apt update && sudo apt install snapd -y
    fi
}

check_libstdc() {
    print_msg "Checking libstdc++ version for Milvus"
    if strings /usr/lib/x86_64-linux-gnu/libstdc++.so.6 | grep -q "GLIBCXX_3.4.29"; then
        echo -e "${GREEN}libstdc++ version is sufficient.${NC}"
    else
        echo -e "${YELLOW}Updating libstdc++...${NC}"
        sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y
        sudo apt update
        sudo apt install gcc-11 g++-11 -y
    fi
}

# --- Installers (Core Logic Only) ---

install_postgres() {
    print_msg "Installing PostgreSQL Server"
    sudo apt install -y curl ca-certificates
    sudo install -d /usr/share/postgresql-common/pgdg
    sudo curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc
    . /etc/os-release
    sudo sh -c "echo 'deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt $VERSION_CODENAME-pgdg main' > /etc/apt/sources.list.d/pgdg.list"
    sudo apt update
    sudo apt install -y postgresql-16 postgresql-contrib-16
    sudo systemctl enable postgresql
    sudo systemctl start postgresql
    echo -e "${GREEN}PostgreSQL Installed & Started!${NC}"
}

install_pgadmin() {
    print_msg "Installing pgAdmin4"
    sudo curl -fsS https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo gpg --dearmor -o /usr/share/keyrings/packages-pgadmin-org.gpg
    sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/packages-pgadmin-org.gpg] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list'
    sudo apt update
    sudo apt install pgadmin4 -y
    echo -e "${GREEN}pgAdmin4 Installed.${NC}"
}

install_mongo() {
    print_msg "Installing MongoDB Server"
    sudo apt-get install -y gnupg curl
    curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | \
       sudo gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg --dearmor --yes
    echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/8.0 multiverse" | \
       sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list
    sudo apt-get update -y
    sudo apt-get install -y mongodb-org
    sudo systemctl start mongod
    sudo systemctl enable mongod
    echo -e "${GREEN}MongoDB Installed & Started!${NC}"
}

install_compass() {
    print_msg "Installing MongoDB Compass"
    wget https://downloads.mongodb.com/compass/mongodb-compass_1.40.4_amd64.deb -O compass.deb
    sudo apt install ./compass.deb -y
    rm compass.deb
    echo -e "${GREEN}Compass Installed.${NC}"
}

install_redis() {
    print_msg "Installing Redis Server"
    sudo apt update
    sudo apt install -y redis-server
    sudo systemctl enable redis-server
    sudo systemctl start redis-server
    echo -e "${GREEN}Redis Installed & Started!${NC}"
}

install_racompass() {
    print_msg "Installing Racompass"
    sudo snap install racompass
    echo -e "${GREEN}Racompass Installed.${NC}"
}

install_milvus() {
    check_libstdc
    print_msg "Installing Milvus (Vector DB)"

    # Using user-specified DEB link (v2.6.9)
    wget -O milvus.deb "https://github.com/milvus-io/milvus/releases/download/v2.6.9/milvus_2.6.9-1_amd64.deb"
    
    print_msg "Installing Milvus Package..."
    sudo dpkg -i milvus.deb
    sudo apt-get -f install -y
    rm milvus.deb
    
    # Attempt to start service
    if [ -f /usr/lib/systemd/system/milvus.service ] || [ -f /lib/systemd/system/milvus.service ]; then
         sudo systemctl daemon-reload
         sudo systemctl start milvus || true
         sudo systemctl enable milvus || true
    fi
    echo -e "${GREEN}Milvus Installed!${NC}"
}

install_attu() {
    print_msg "Installing Attu"
    wget -O attu.deb "https://github.com/zilliztech/attu/releases/download/v2.6.4/attu_2.6.4_amd64.deb"
    sudo apt install ./attu.deb -y
    rm attu.deb
    echo -e "${GREEN}Attu Installed.${NC}"
}

install_dbeaver() {
    print_msg "Installing DBeaver"
    sudo snap install dbeaver-ce --classic
    echo -e "${GREEN}DBeaver Installed.${NC}"
}

install_beekeeper() {
    print_msg "Installing Beekeeper Studio"
    sudo snap install beekeeper-studio
    echo -e "${GREEN}Beekeeper Installed.${NC}"
}

# --- Main ---

clear
echo -e "${BLUE}${BOLD}Database Tools & Servers${NC}"
echo -e "------------------------"

setup_snap

# PostgreSQL Stack
echo -e "\n${YELLOW}--- PostgreSQL Stack ---${NC}"
check_and_ask "PostgreSQL Server" "psql" install_postgres
check_and_ask "pgAdmin4 (GUI)" "pgadmin4" install_pgadmin

# MongoDB Stack
echo -e "\n${YELLOW}--- MongoDB Stack ---${NC}"
check_and_ask "MongoDB Server" "mongod" install_mongo
check_and_ask "MongoDB Compass (GUI)" "mongodb-compass" install_compass

# Redis Stack
echo -e "\n${YELLOW}--- Redis Stack ---${NC}"
check_and_ask "Redis Server" "redis-server" install_redis
check_and_ask "Racompass (GUI)" "racompass" install_racompass

# Milvus Stack
echo -e "\n${YELLOW}--- Milvus Stack ---${NC}"
check_and_ask "Milvus (Vector DB)" "milvus" install_milvus "dpkg"
check_and_ask "Attu (GUI)" "attu" install_attu "dpkg"

# Universal
echo -e "\n${YELLOW}--- Universal Tools ---${NC}"
check_and_ask "DBeaver" "dbeaver-ce" install_dbeaver
check_and_ask "Beekeeper Studio" "beekeeper-studio" install_beekeeper

echo -e "\n${GREEN}DB Tools Setup Complete! 🗄️${NC}\n"
