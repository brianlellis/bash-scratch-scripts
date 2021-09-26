#!/bin/bash
# For More Info http://clivern.com/how-to-install-apache-tomcat-8-on-ubuntu-16-04

sudo apt-get install aptitude
sudo aptitude update
aptitude -y upgrade
aptitude -y install apache2
wget http://cdn.lucee.org/lucee-5.2.4.037-pl0-linux-x64-installer.run -O lucee.run
chmod 744 lucee.run
sudo ./lucee.run

##
mv /var/www/html /var/www/backup_html

cp -r bin cache cfclasses/ components/ context/ customtags/ deploy/ exe-log id lib lib-hash locales/ logs/ lucee-web.xml.cfm remote-client/ scheduler/ security/ storage/ temp/ version video/ /var/www/html/WEB-INF/lucee/
cp -r fld function tld /var/www/html/WEB-INF/lucee/library/
sudo /opt/lucee/lucee_ctl restart

## MAKE SURE THE IP FOR THE IP IS IN THE SECURITY GROUP RULES FOR INBOUND IF HAVING CONNECTION ISSUES
## MAKE SURE TO EDIT /etc/apache2/sites-enable config file with: DirectoryIndex index.cfm

sudo a2enmod rewrite
sudo service apache2 restart
