sudo apt update && sudo apt upgrade;
sudo apt install apache2;
sudo systemctl enable apache2;
sudo systemctl start apache2;
sudo apt install unzip wget php7.2 php7.2-bcmath php7.2-cgi php7.2-cli php7.2-common php-curl php7.2-dba php7.2-enchant php7.2-fpm php7.2-gd php7.2-imap php7.2-intl php7.2-ldap php7.2-mbstring php7.2-mysql php7.2-opcache php-imagick php-memcache php7.2-soap php7.2-tidy php7.2-xml php7.2-zip libapache2-mod-php7.2 xvfb libfontconfig wkhtmltopdf;
sudo vim /etc/php/7.2/apache2/php.ini;
  post_max_size = 200M
  upload_max_filesize = 200M
  max_execution_time = 300
  memory_limit = 512M
  max_input_vars = 5000
sudo systemctl restart apache2;
sudo apt install mariadb-server;
sudo mysql_secure_installation;
sudo mysql -u root -proot
CREATE DATABASE orangescrum;
GRANT ALL PRIVILEGES ON orangescrumdb.* TO 'orangescrumuser'@'localhost' IDENTIFIED BY 'orangescrumbpss';
FLUSH PRIVILEGES;
exit;
sudo vim /etc/mysql/conf.d/disable_strict_mode.cnf;
  [mysqld]
  sql_mode="IGNORE_SPACE,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION"
sudo systemctl restart mariadb;
cd /tmp;
wget https://www.orangescrum.org/free-download/418ae4d8ef1309695804a7837cd4fc65/ubuntu18-php7 -O orangescrum-ubuntu18-php7.zip;
unzip orangescrum-ubuntu18-php7.zip;
sudo cp -r orangescrum-ubuntu18-php7 /var/www/html/orangescrum-master;
cd /var/www/html/orangescrum-master;
sudo mysql -u orangescrumuser -porangescrumbpss orangescrumdb < database.sql
sudo vim app/Config/database.php;
  ADD YOUR CREDENTIALS TO THE FILE
sudo vim app/Config/config.ini.php;
sudo chown -R www-data:www-data /var/www/html/orangescrum-master/;
sudo chmod -R 775 /var/www/html/orangescrum-master/;
sudo phpenmod mbstring;
sudo a2enmod rewrite;
sudo a2enmod headers;
sudo systemctl restart apache2;
