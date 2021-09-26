######################## PHP 7.2
sudo add-apt-repository ppa:ondrej/php
sudo apt-get update
sudo apt install -y php7.2-fpm php7.2-common php7.2-mbstring php7.2-xmlrpc php7.2-gd php7.2-xml php7.2-mysql php7.2-cli php7.2-zip php7.2-curl

# NGINX
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install nginx -y
sudo systemctl status nginx
sudo systemctl start nginx
sudo systemctl enable nginx

## SETUP DEFAULT SITES-AVAILABLE MAPPING
sudo rm /etc/nginx/sites-available/default
sudo cat > /etc/nginx/sites-available/default <<EOF
server {

    listen 80;
    server_name localhost;
    root /var/www/public;

    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Content-Type-Options "nosniff";

    index index.php;

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

    ##
    ## fastcgi_cache start
    ##
    set $no_cache 0;

    # POST requests and urls with a query string should always go to PHP
    if ($request_method = POST) {
        set $no_cache 1;
    }
    if ($query_string != "") {
        set $no_cache 1;
    }

    # Don't cache uris containing the following segments
    if ($request_uri ~* "(/wp-admin/|/xmlrpc.php|/wp-(app|cron|login|register|mail).php|wp-.*.php|/feed/|index.php|wp-comments-popup.php|wp-links-opml.php|wp-locations.php|sitemap(_index)?.xml|[a-z0-9_-]+-sitemap([0-9]+)?.xml)") {
        set $no_cache 1;
    }

    # Don't use the cache for logged in users or recent commenters
    if ($http_cookie ~* "comment_author|wordpress_[a-f0-9]+|wp-postpass|wordpress_no_cache|wordpress_logged_in") {
        set $no_cache 1;
    }

    charset utf-8;

    location / {
        try_files $uri $uri/ /index.php$is_args$args;
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
      fastcgi_cache_bypass $no_cache;
      fastcgi_no_cache $no_cache;
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


######################## REDIS
sudo apt-get install -y build-essential tcl software-properties-common

# See https://www.hugeserver.com/kb/install-redis-4-debian-9-stretch/
sudo wget http://download.redis.io/releases/redis-stable.tar.gz
sudo tar xvzf redis-stable.tar.gz
cd redis-stable/
sudo make && sudo make install
sudo make test
cd utils/
sudo ./install_server.sh
sudo systemctl start redis_6379
sudo systemctl enable redis_6379

cd ../../
sudo rm redis-stable -rf
sudo rm redis-stable.tar.gz

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
source ~/.profile

######################## WP-CLI
sudo curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
sudo chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

######################## WORDPRESS
sudo mkdir /var/www/public
cd /var/www/public

echo "================================================================="
echo "Awesome WordPress Installer!!"
echo "================================================================="

# Website address
echo "Website Address: "
read -e url

# accept user input for the database name
echo "Database Name: "
read -e dbname

# accept the name of our website
echo "Site Name: "
read -e sitename

# add a simple yes/no confirmation before we proceed
echo "Run Install? (y/n)"
read -e run

# if the user didn't say no, then go ahead an install
if [ "$run" == n ] ; then
exit
else

# download the WordPress core files
sudo wp core download --allow-root

# create the wp-config file
sudo wp core config --dbname=$dbname --dbuser=root --dbpass=root --allow-root

# parse the current directory name

currentdirectory=${PWD##*/}
wpuser=$(LC_CTYPE=C tr -dc A-Za-z0-9 < /dev/urandom | head -c 5)
password=$(LC_CTYPE=C tr -dc A-Za-z0-9_\!\@\#\$\%\^\&\*\(\)-+= < /dev/urandom | head -c 12)
sudo wp db create --allow-root
sudo wp core install --url="$url" --title="$sitename" --admin_user="$wpuser" --admin_password="$password" --admin_email="user@example.org"  --allow-root
clear

echo "================================================================="
echo "Installation is complete. Your username/password is listed below."
echo ""
echo "Username: $wpuser"
echo "Password: $password"
echo ""
echo "================================================================="

fi


### KNOWN ISSUES #####
# WP CAN'T CONNECT BECAUSE ROOT OF MYSQL NOT ALLOWING ANYTHING BUT SUDO
#https://askubuntu.com/questions/766334/cant-login-as-mysql-user-root-from-normal-user-account-in-ubuntu-16-04/801950
#https://stackoverflow.com/questions/17975120/access-denied-for-user-rootlocalhost-using-password-yes-no-privileges

######################## COMPOSER
sudo apt update;
sudo apt install -y git php-zip unzip;
sudo php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');";
HASH="$(wget -q -O - https://composer.github.io/installer.sig)";
sudo php -r "if (hash_file('SHA384', 'composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;";
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer;
source ~/.profile
composer

######################## WP SAGE THEME DEPENDENCY BUILD
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update
sudo apt install -y yarn

######################## WP FILE PERMISSION
WP_OWNER=www-data
WP_GROUP=www-data
WP_ROOT="/var/www/public/"
WS_GROUP=www-data

sudo find ${WP_ROOT} -exec chown ${WP_OWNER}:${WP_GROUP} {} \;
sudo find ${WP_ROOT} -type d -exec chmod 755 {} \;
sudo find ${WP_ROOT} -type f -exec chmod 644 {} \;

sudo chgrp ${WS_GROUP} ${WP_ROOT}wp-config.php
sudo chmod 660 ${WP_ROOT}wp-config.php

sudo chgrp ${WS_GROUP} ${WP_ROOT}/wp-config.php
sudo chmod 660 ${WP_ROOT}/wp-config.php

######################## WP SAGE THEME INSTALLATION
cd wp-content/themes

# define theme name
echo "What is the theme name?"
read -e themename

sudo composer create-project roots/sage $themename
cd $themename
sudo yarn
# First production build
sudo yarn build:production


######################## WP PLUGINS BUILD
# REDIS
sudo wp plugin install redis-cache --allow-root
sudo wp plugin activate redis-cache --allow-root
sudo wp redis enable --allow-root
sudo wp redis status --allow-root
