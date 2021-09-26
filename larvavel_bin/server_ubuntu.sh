#!/bin/bash

### IF PERMISSIONS ARE OFF
chown root:root /tmp
chmod ugo+rwXt /tmp

######################## PHP 7.2
sudo apt-get update &&
sudo add-apt-repository ppa:ondrej/php &&
sudo add-apt-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) universe" &&
sudo apt-get update &&
sudo apt install -y php7.2-fpm php7.2-common php7.2-mbstring php7.2-xmlrpc &&
sudo apt install -y php7.2-gd php7.2-xml php7.2-mysql php7.2-cli php7.2-zip &&
sudo apt install -y php7.2-curl php7.2-ldap mcrypt php7.2-tidy php7.2-bcmath &&
sudo apt-get install -y libnotify-bin git unzip build-essential libssl-dev

######################## COMPOSER
sudo apt update &&
sudo php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" &&
HASH="$(wget -q -O - https://composer.github.io/installer.sig)" &&
sudo php -r "if (hash_file('SHA384', 'composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" &&
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer &&
source ~/.profile &&
composer

# NODEJS + NVM
sudo su &&
cd ~ &&
sudo apt-get update &&
sudo apt-get install build-essential libssl-dev &&
curl -sL https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh -o install_nvm.sh &&
bash install_nvm.sh &&
source ~/.profile &&

# LINK FOR SUDO USAGE BY COPYING CURRENT NVM USAGE TO USR/LOCAL
n=$(which node); \
n=${n%/bin/node}; \
sudo chmod -R 755 $n/bin/*; \
sudo cp -r $n/{bin,lib,share} /usr/local

source ~/.profile &&
sudo nvm install 10 &&
sudo nvm use 10 &&

######################## PYTHON FOR SASS FUNCTIONALITY
sudo apt-get update &&
sudo apt-get install -y python2.7 python-minimal &&
sudo ln -s /usr/bin/python2.7 /usr/bin/python

########################  YARN SETUP
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update
sudo apt install -y yarn

########################  GULP SETUP
sudo npm install gulp-cli -g

######################## NGINX
sudo apt-get update && sudo apt-get upgrade -y &&
sudo apt-get install -y nginx php7.2-fpm &&
sudo systemctl stop nginx.service &&
sudo systemctl stop php7.2-fpm.service

sudo cat > /etc/nginx/sites-available/default <<EOF
# Expires map
map $sent_http_content_type $expires {
   default                    off;
   text/html                  epoch;
   text/css                   max;
   application/javascript     max;
   ~image/                    max;
}

server {
    listen 80;
    listen [::]:80;
    root /var/www/html/application/public;
    index  index.php index.html index.htm;
    server_name  suretypedia.jepdevs.com;

    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Content-Type-Options "nosniff";

    ##
    # Gzip Settings
    ##
    gzip  on;
    gzip_comp_level 2;
    gzip_buffers 16 8k;
    gzip_disable "MSIE [1-6]\.";
    gzip_proxied any;
    gzip_types text/plain text/css application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript;

    charset utf-8;
    expires $expires;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    error_page 404 /index.php;

    location ~ \.php$ {
      fastcgi_split_path_info ^(.+\.php)(/.+)$;
      fastcgi_pass unix:/var/run/php/php7.2-fpm.sock;
      include fastcgi_params;
      fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
      fastcgi_intercept_errors off;
      include snippets/fastcgi-php.conf;

      include fastcgi_params;
      fastcgi_buffer_size 128k;
      fastcgi_connect_timeout 60s;
      fastcgi_send_timeout 60s;
      fastcgi_read_timeout 60s;
      fastcgi_buffers 256 16k;
      fastcgi_busy_buffers_size 256k;
      fastcgi_temp_file_write_size 256k;
    }

    location ~ /\.(?!well-known).* {
        deny all;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF

sudo systemctl start nginx.service &&
sudo systemctl start php7.2-fpm.service

######################## MARIA DB
sudo apt update &&
sudo apt-get install -y software-properties-common &&
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8 &&
sudo add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://nyc2.mirrors.digitalocean.com/mariadb/repo/10.2/ubuntu xenial main' &&
sudo apt-get update &&
sudo apt-get install -y mariadb-server mariadb-client

######################## FROSTBITE SETUP OF REPOS
cd /var/www &&
sudo cp -r html old_html &&
sudo rm html/index.nginx-debian.html &&
cd html &&
sudo chown -R www-data:www-data ./

sudo git clone https://github.com/jep-capital-devs/app_core_laravel.git &&
sudo git clone https://github.com/jep-capital-devs/app_theme_jetsurety.git &&
sudo cp -r app_core_laravel/bin app_theme_jetsurety/bin &&
cd app_theme_jetsurety/bin &&
sudo ./coreinstall.sh

########### CREATE DATABASE
echo -n "Do you want to use another branch besides master? (y/n)"
mysql -uroot -proot -e "create database jetusrety"

########### REGISTER ENV FILE AND DB IN LARAVEL
cat > ../.env <<EOF
APP_NAME=Laravel
APP_ENV=local
APP_KEY=base64:tlV38aWz0tVYpUA8tSZGvvS5umYWiNuDOWI7VK2Tu/M=
APP_DEBUG=true
APP_URL=http://jetsurety.jepdevs.com

LOG_CHANNEL=stack

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=jetsurety
DB_USERNAME=root
DB_PASSWORD=root

BROADCAST_DRIVER=log
CACHE_DRIVER=file
QUEUE_CONNECTION=sync
SESSION_DRIVER=file
SESSION_LIFETIME=120

REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379

MAIL_DRIVER=smtp
MAIL_HOST=smtp.mailtrap.io
MAIL_PORT=2525
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null

AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_DEFAULT_REGION=us-east-1
AWS_BUCKET=

PUSHER_APP_ID=
PUSHER_APP_KEY=
PUSHER_APP_SECRET=
PUSHER_APP_CLUSTER=mt1

MIX_PUSHER_APP_KEY="${PUSHER_APP_KEY}"
MIX_PUSHER_APP_CLUSTER="${PUSHER_APP_CLUSTER}"
EOF

########### SET UP DB AND GENERATE APP KEY
cd .. &&
sudo composer install &&
sudo php artisan key:generate  --no-interaction --force &&
sudo php artisan migrate  --no-interaction --force &&
sudo php artisan db:seed

########### VOYAGER ADMIN CREATOR
sudo php artisan voyager:install &&
php artisan voyager:admin --create

########### BUILD FRONTEND TOOLS OUT
cd resources/views/themes/frostbite/assets &&
sudo su &&
sudo npm install && gulp css && gulp lintjs &&
exit

########### INSTALL NECESSARY MODULES
cd ../../../../../bin &&
sudo chmod +x modules.sh data.sh &&
sudo ./modules.sh &&
sudo ./data.sh

##### PERMISSSIONS
cd ..
sudo find ./ -type d -exec chmod 755 {} \;
sudo find ./ -type f -exec chmod 644 {} \;
sudo chown -R www-data:www-data ./;
