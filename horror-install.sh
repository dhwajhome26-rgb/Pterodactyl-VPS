#!/usr/bin/env bash

clear
echo "=============================="
echo "       HORROR PANEL"
echo "=============================="
echo ""
echo "( 1 ) Install Panel"
echo "( 2 ) Install Wings"
echo ""
read -p "[ Select Number ]: " choice

if [ "$choice" == "1" ]; then
  echo ""
  echo "== Installing HORROR PANEL =="
  read -p "Enter domain (panel.example.com): " DOMAIN

  echo ""
  echo "Updating system..."
  sudo apt update -y && sudo apt upgrade -y

  echo "Installing dependencies..."
  sudo apt install -y curl ca-certificates gnupg lsb-release

  echo "Installing Docker..."
  curl -fsSL https://get.docker.com | sh

  echo "Installing Node, Nginx..."
  curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
  sudo apt install -y nodejs nginx

  echo "Setting up Panel files..."
  mkdir -p /var/www/horror-panel
  unzip panel.zip -d /var/www/horror-panel

  echo "Configuring Nginx..."
  sudo tee /etc/nginx/sites-available/horror-panel <<EOF
server {
  listen 80;
  server_name $DOMAIN;

  root /var/www/horror-panel/public;
  index index.html;

  location / {
    try_files \$uri /index.html;
  }
}
EOF

  sudo ln -s /etc/nginx/sites-available/horror-panel /etc/nginx/sites-enabled/
  sudo nginx -t && sudo systemctl reload nginx

  echo ""
  read -p "Create Admin now? (Yes/No): " ADMIN

  if [[ "$ADMIN" =~ ^[Yy]([Ee][Ss])?$ ]]; then
    read -p "Enter email: " EMAIL
    read -p "Username: " USERNAME
    read -p "First name: " FIRST
    read -p "Last name: " LAST

    echo ""
    echo "Creating admin user..."
    echo "Admin created:"
    echo "Email: $EMAIL"
    echo "Username: $USERNAME"
    echo "Name: $FIRST $LAST"
    # Yahan tum apna real create-admin command lagana
  fi

  echo ""
  echo "HORROR PANEL Installed Successfully!"
  echo "Open: http://$DOMAIN"

elif [ "$choice" == "2" ]; then
  echo ""
  echo "== Installing HORROR WINGS (Node) =="

  echo "Updating system..."
  sudo apt update -y

  echo "Installing Docker..."
  curl -fsSL https://get.docker.com | sh

  echo "Downloading Wings..."
  sudo mkdir -p /etc/pterodactyl
  curl -L -o /usr/local/bin/wings https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_amd64
  sudo chmod +x /usr/local/bin/wings

  echo ""
  echo "Wings installed."
  echo "Now go to your Panel -> Create Node -> Copy config.yml"
  echo "Paste it into /etc/pterodactyl/config.yml"

  echo ""
  echo "Then run:"
  echo "wings --debug"

else
  echo "Invalid option!"
fi
