sudo apt update
sudo apt install apache2

sudo systemctl stop apache2.service
sudo systemctl start apache2.service
sudo systemctl enable apache2.service

sudo apt-get install mariadb-server mariadb-client

sudo systemctl stop mysql.service
sudo systemctl start mysql.service
sudo systemctl enable mysql.service

sudo mysql_secure_installation

sudo apt-get install software-properties-common
sudo add-apt-repository ppa:ondrej/php

sudo apt update

sudo apt install php7.2 php7.2-bcmath php7.2-cgi php7.2-cli php7.2-common php-curl php7.2-dba php7.2-enchant php7.2-fpm
sudo apt install php7.2-gd php7.2-imap php7.2-intl php7.2-ldap php7.2-mbstring php7.2-mysql php7.2-opcache php-imagick
sudo apt install php-memcache php7.2-soap php7.2-tidy php7.2-xml php7.2-zip libapache2-mod-php7.2 xvfb libfontconfig wkhtmltopdf
sudo apt install unzip

sudo vim /etc/php/7.2/apache2/php.ini
  file_uploads = On
  allow_url_fopen = On
  short_open_tag = On
  memory_limit = 256M
  upload_max_filesize = 200M
  max_execution_time = 360
  date.timezone = America/Chicago

sudo systemctl restart apache2.service

sudo vim /var/www/html/phpinfo.php
  <?php phpinfo( ); ?>

sudo mysql -u root -proot
  CREATE DATABASE orangescrum;
  CREATE USER 'orangescrumuser'@'localhost' IDENTIFIED BY 'orangepass';
  GRANT ALL ON orangescrum.* TO 'orangescrumuser'@'localhost' IDENTIFIED BY 'orangepass' WITH GRANT OPTION;
  FLUSH PRIVILEGES;
  EXIT;

cd /tmp
wget https://www.orangescrum.org/free-download/418ae4d8ef1309695804a7837cd4fc65/ubuntu18-php7 -O orangescrum-ubuntu18-php7.zip
unzip orangescrum-ubuntu18-php7.zip
sudo mv orangescrum-ubuntu18-php7 /var/www/html/orangescrum-master

sudo chown -R www-data:www-data /var/www/html/orangescrum-master/
sudo chmod -R 755 /var/www/html/orangescrum-master/

cd /var/www/html/orangescrum-master/
sudo mysql -u orangescrumuser -porangepass orangescrum < database.sql

sudo vim /var/www/html/orangescrum-master/app/Config/database.php
  class DATABASE_CONFIG {
    public $default = array(
                        'datasource' => 'Database/Mysql',
                        'persistent' => false,
                        'host' => 'localhost',
                        'login' => 'orangescrumuser',
                        'password' => 'new_password_here',
                        'database' => 'orangescrum',
                        'prefix' => '',
                        'encoding' => 'utf8',
                      );
  }

sudo vim /etc/apache2/sites-available/orangescrum.conf
  <VirtualHost *:80>
     ServerAdmin admin@example.com
     DocumentRoot /var/www/html/orangescrum-master
     ServerName project.bxstaging.com
     ServerAlias project.bxstaging.com

     <Directory /var/www/html/orangescrum-master/>
          Options FollowSymlinks
          AllowOverride All
          Require all granted
     </Directory>

     ErrorLog ${APACHE_LOG_DIR}/error.log
     CustomLog ${APACHE_LOG_DIR}/access.log combined

     <Directory /var/www/html/orangescrum-master/>
            RewriteEngine on
            RewriteBase /
            RewriteCond %{REQUEST_FILENAME} !-f
            RewriteRule ^(.*) index.php [PT,L]
    </Directory>
  </VirtualHost>

sudo a2ensite orangescrum.conf
sudo a2enmod rewrite
sudo phpenmod mbstring
sudo a2enmod headers
sudo systemctl restart apache2.service
