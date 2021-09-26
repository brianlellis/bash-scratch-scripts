#!/bin/bash

### IF PERMISSIONS ARE OFF
chown root:root /tmp
chmod ugo+rwXt /tmp

######################## PHP 7.2
sudo add-apt-repository ppa:ondrej/php
sudo apt-get update
sudo add-apt-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) universe"
sudo apt install -y php7.2-fpm php7.2-curl php7.2-mbstring php7.2-ldap
sudo apt install -y php7.2-tidy php7.2-xml php7.2-zip php7.2-gd php7.2-mysql mcrypt

######################## NGINX
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y nginx php7.2-fpm
sudo systemctl stop nginx.service
sudo systemctl stop php7.2-fpm.service

######################## COMPOSER
sudo apt update;
sudo apt install -y git unzip;
sudo php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');";
HASH="$(wget -q -O - https://composer.github.io/installer.sig)";
sudo php -r "if (hash_file('SHA384', 'composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;";
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer;
source ~/.profile
composer


## SETUP DEFAULT SITES-AVAILABLE MAPPING
sudo cat > /etc/nginx/sites-available/default <<EOF
server {

    listen 80;
    server_name localhost;
    root /var/www/public/public;

    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Content-Type-Options "nosniff";

    index index.php index.html;

    ##
    # Gzip Settings
    ##
    gzip  on;
    gzip_comp_level 2;
    gzip_buffers 16 8k;
    gzip_disable "MSIE [1-6]\.";
    gzip_proxied any;
    gzip_types text/plain text/css application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript;


    location ~* \.(jpg|jpeg|gif|css|png|js|ico|html)$ {
        access_log off;
        expires max;
        log_not_found off;
    }


    charset utf-8;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    access_log off;
    error_log  /var/log/nginx/localhost-error.log error;

    client_max_body_size 100m;

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

    location ~ /\.ht {
        deny all;
    }
}
EOF

sudo systemctl start nginx.service
sudo systemctl start php7.2-fpm.service

######################## MARIA DB
sudo apt-get install -y software-properties-common;
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8;
sudo add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://nyc2.mirrors.digitalocean.com/mariadb/repo/10.2/ubuntu xenial main';
sudo apt-get update;
sudo apt-get install -y mariadb-server mariadb-client
mysql -u root -proot -e "create database bookstack";

######################## BOOKSTACK INSTALLATION
sudo mkdir /var/www/public
cd /var/www/public
sudo apt install -y git
sudo git clone https://github.com/BookStackApp/BookStack.git --branch release --single-branch .

sudo composer install

sudo touch /var/www/public/.env
sudo cat > /var/www/public/.env <<EOF
# Environment
APP_ENV=production
APP_DEBUG=false
APP_KEY=SomeRandomString

# The below url has to be set if using social auth options
# or if you are not using BookStack at the root path of your domain.
# APP_URL=http://bookstack.dev

# Database details
DB_HOST=localhost
DB_DATABASE=bookstack
DB_USERNAME=root
DB_PASSWORD=root

# Cache and session
CACHE_DRIVER=file
SESSION_DRIVER=file
# If using Memcached, comment the above and uncomment these
#CACHE_DRIVER=memcached
#SESSION_DRIVER=memcached
QUEUE_DRIVER=sync
# A different prefix is useful when multiple BookStack instances use the same caching server
CACHE_PREFIX=bookstack

# Memcached settings
# If using a UNIX socket path for the host, set the port to 0
# This follows the following format: HOST:PORT:WEIGHT
# For multiple servers separate with a comma
MEMCACHED_SERVERS=127.0.0.1:11211:100

# Storage
STORAGE_TYPE=local
# Amazon S3 Config
STORAGE_S3_KEY=false
STORAGE_S3_SECRET=false
STORAGE_S3_REGION=false
STORAGE_S3_BUCKET=false
# Storage URL
# Used to prefix image urls for when using custom domains/cdns
STORAGE_URL=false

# General auth
AUTH_METHOD=standard

# Social Authentication information. Defaults as off.
GITHUB_APP_ID=false
GITHUB_APP_SECRET=false
GOOGLE_APP_ID=false
GOOGLE_APP_SECRET=false
GOOGLE_SELECT_ACCOUNT=false
OKTA_BASE_URL=false
OKTA_APP_ID=false
OKTA_APP_SECRET=false
TWITCH_APP_ID=false
TWITCH_APP_SECRET=false
GITLAB_APP_ID=false
GITLAB_APP_SECRET=false
GITLAB_BASE_URI=false
DISCORD_APP_ID=false
DISCORD_APP_SECRET=false

# External services such as Gravatar and Draw.IO
DISABLE_EXTERNAL_SERVICES=false

# LDAP Settings
LDAP_SERVER=false
LDAP_BASE_DN=false
LDAP_DN=false
LDAP_PASS=false
LDAP_USER_FILTER=false
LDAP_VERSION=false
# Do you want to sync LDAP groups to BookStack roles for a user
LDAP_USER_TO_GROUPS=false
# What is the LDAP attribute for group memberships
LDAP_GROUP_ATTRIBUTE="memberOf"
# Would you like to remove users from roles on BookStack if they do not match on LDAP
# If false, the ldap groups-roles sync will only add users to roles
LDAP_REMOVE_FROM_GROUPS=false

# Mail settings
MAIL_DRIVER=smtp
MAIL_HOST=localhost
MAIL_PORT=1025
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
MAIL_FROM=null
MAIL_FROM_NAME=null
EOF


##GENERATE UNIQUE APPLICATION KEY
# Generate the application key
sudo php artisan key:generate --no-interaction --force
# Migrate the databases
sudo php artisan migrate --no-interaction --force

######################## Bookstack FILE PERMISSION
sudo chown www-data:www-data -R /var/www/public/bootstrap/cache /var/www/public/public/uploads storage && sudo chmod -R 755 /var/www/public/bootstrap/cache /var/www/public/public/uploads /var/www/public/storage

echo ""
echo "Setup Finished, Your BookStack instance should now be installed."
echo "You can login with the email 'admin@admin.com' and password of 'password'"
echo "MySQL was installed without a root password, It is recommended that you set a root MySQL password."
echo ""
