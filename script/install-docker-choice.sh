#!/bin/bash

# Function to install Docker on Debian/Ubuntu
install_docker_debian() {
    echo "Updating the system..."
    sudo apt-get update -y

    echo "Installing required dependencies..."
    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

    echo "Adding Docker's official GPG key..."
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    echo "Setting up the stable repository..."
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    echo "Installing Docker Engine..."
    sudo apt-get update -y
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io

    echo "Starting and enabling Docker service..."
    sudo systemctl start docker
    sudo systemctl enable docker

    echo "Verifying Docker installation..."
    sudo systemctl status docker
}

# Function to install Docker on RHEL
install_docker_rhel() {
    echo "Updating the system..."
    sudo dnf update -y

    echo "Installing required dependencies..."
    sudo dnf install -y yum-utils device-mapper-persistent-data lvm2

    echo "Adding Docker repository..."
    sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo

    echo "Installing Docker CE..."
    sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    echo "Starting and enabling Docker service..."
    sudo systemctl start docker
    sudo systemctl enable docker

    echo "Verifying Docker installation..."
    sudo systemctl status docker
}

# Function to prompt user for OS selection
choose_os() {
    echo "Please select your OS:"
    echo "1. Debian/Ubuntu"
    echo "2. RHEL"

    read -p "Enter the number corresponding to your OS: " os_choice

    case $os_choice in
        1)
            install_docker_debian
            ;;
        2)
            install_docker_rhel
            ;;
        *)
            echo "Invalid choice. Please run the script again and select 1 or 2."
            ;;
    esac
}

# Main script execution
choose_os
