#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Update system packages
echo "Updating system..."
sudo apt update && sudo apt upgrade -y

# Install essential packages
PACKAGES=(
    sudo
    curl
    systemd
    docker.io
    docker-compose
    net-tools
    git
    vim
    unzip
    wget
    tree
    htop
    build-essential
    ufw
    nginx
    certbot
    python3-certbot-nginx
    mariadb-server
    redis-server
    php-cli
    php-mysql
    php-zip
    php-gd
    php-mbstring
    php-curl
    php-xml
    php-bcmath
    php-tokenizer
    php-common
)

echo "Installing essential packages..."
for package in "${PACKAGES[@]}"; do
    if command_exists "$package"; then
        echo "$package is already installed."
    else
        sudo apt install -y "$package"
    fi
done

# Start and enable services
echo "Enabling required services..."
sudo systemctl enable --now docker mariadb redis nginx

# Configure UFW firewall
echo "Configuring UFW firewall..."
sudo ufw allow OpenSSH
sudo ufw allow 80
sudo ufw allow 443
sudo ufw allow 8080
sudo ufw allow 2022
sudo ufw --force enable

# Install Composer (for PHP dependencies)
echo "Installing Composer..."
if ! command_exists composer; then
    curl -sS https://getcomposer.org/installer | php
    sudo mv composer.phar /usr/local/bin/composer
else
    echo "Composer is already installed."
fi

# Install Node.js & npm (required for Pterodactyl)
echo "Installing Node.js and npm..."
if ! command_exists node; then
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt install -y nodejs
else
    echo "Node.js is already installed."
fi

# Install Yarn package manager
echo "Installing Yarn..."
if ! command_exists yarn; then
    npm install --global yarn
else
    echo "Yarn is already installed."
fi

# Verify installations
echo "Verifying installations..."
docker --version
docker-compose --version
curl --version
sudo --version
systemctl --version
git --version
vim --version
ufw status
nginx -v
mariadb --version
redis-server --version
php --version
composer --version
node -v
npm -v
yarn -v

echo "Installation completed successfully!"
