#!/bin/bash

echo -n "Do you want to use another branch besides master? (y/n) "
read ANOTHER_BRANCH
if [[ $ANOTHER_BRANCH == y* ]]; then
  echo -n "What is the name of the branch to be used? "
  read SELECTED_BRANCH
  git checkout $SELECTED_BRANCH
fi

clear
echo "===================="
echo "==== CORE SETUP ===="
echo "===================="
./coreinstall.sh

# CREATE DATABASE?
clear
echo "===================="
echo "===== DB SETUP ====="
echo "===================="
echo -n "What is the new database name? "
read DB_NAME

echo -n "What is the mysql user? "
read DB_USER

echo -n "What is the mysql pass? "
read DB_PASS

echo "create database $DB_NAME" | mysql -u$DB_USER -p$DB_PASS


#Setup Valet
cd .. && clear
echo "====================="
echo "==== VALET SETUP ===="
echo "====================="
echo -n "What is the project name? "
read PROJECT_NAME
valet link $PROJECT_NAME

# REGISTER ENV FILE AND DB IN LARAVEL
cat > .env <<EOF
APP_NAME=Laravel
APP_ENV=local
APP_KEY=base64:tlV38aWz0tVYpUA8tSZGvvS5umYWiNuDOWI7VK2Tu/M=
APP_DEBUG=true
APP_URL=http://$PROJECT_NAME.test

LOG_CHANNEL=stack

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=$DB_NAME
DB_USERNAME=$DB_USER
DB_PASSWORD=$DB_PASS

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

MIX_PUSHER_APP_KEY="\${PUSHER_APP_KEY}"
MIX_PUSHER_APP_CLUSTER="\${PUSHER_APP_CLUSTER}"
EOF

#SET UP DB AND GENERATE APP KEY
composer install
php artisan key:generate
php artisan migrate

#SEED THE DB
php artisan db:seed

# VOYAGER ADMIN CREATOR
php artisan voyager:install
clear
echo "===================="
echo "=== CREATE ADMIN ==="
echo "===================="
php artisan voyager:admin --create

#BUILD FRONTEND TOOLS OUT
clear
echo "==================="
echo "= FRONT-END TOOLS ="
echo "==================="
cd resources/views/themes/frostbite/assets
npm install && gulp css && gulp lintcss

#INSTALL NECESSARY MODULES
clear
cd ../../../../../bin
echo "==================="
echo "= MODULES INSTALL ="
echo "==================="
sh ./modules.sh

#OPEN CHROME
clear
echo "======================================================================"
echo "= PLEASE ACTIVATE THE CORRECT THEME FOR THE FRONT-END TO BE VIEWABLE ="
echo "======================================================================"
open -a "Google Chrome" http://$PROJECT_NAME.test/admin/themes
