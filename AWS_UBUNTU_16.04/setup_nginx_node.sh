#!/bin/bash

# NGINX
sudo apt-get update && sudo apt-get upgrade -y;
sudo apt-get install nginx -y;
sudo systemctl status nginx;
sudo systemctl start nginx;
sudo systemctl enable nginx;

# NODEJS + NVM
cd ~
sudo apt-get update
sudo apt-get install build-essential libssl-dev
curl -sL https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh -o install_nvm.sh
bash install_nvm.sh
source ~/.profile
nvm install 10
nvm use 10

# LINK FOR SUDO USAGE BY COPYING CURRENT NVM USAGE TO USR/LOCAL
n=$(which node); \
n=${n%/bin/node}; \
sudo chmod -R 755 $n/bin/*; \
sudo cp -r $n/{bin,lib,share} /usr/local

#YARN SETUP
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -;
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list;
sudo apt-get update && sudo apt-get install yarnl;
sudo apt-get install --no-install-recommends yarn;
yarn -v;


## SETUP DEFAULT SITES-AVAILABLE MAPPING
sudo rm /etc/nginx/sites-available/default;

sudo cat > /etc/nginx/sites-available/default <<EOF 
# Default server configuration
#
server {
  listen 80;
  root /var/www/html;

  server_name _;

  location / {
    proxy_pass http://127.0.0.1:8080;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host $host;
    proxy_cache_bypass $http_upgrade;
    proxy_redirect off;
  }
}
EOF

sudo systemctl reload nginx;

## MONGODB SETUP
sudo apt-get install mongodb -y;
sudo apt-get update -y;
sudo systemctl start mongodb;
sudo systemctl status mongodb;
