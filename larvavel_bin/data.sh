#!/bin/bash

cd ..

# LOOP THROUGH EACH DEFINED MODULE IN frostbite.config
while read MODULE; do
  # SKIP COMMENTS
  [[ "$MODULE" =~ ^[[:space:]]*# ]] && continue

  MODULE_VENDOR="$(cut -d'_' -f1 <<<$MODULE)"
  # CAPTALIZE MODULE VENDOR NAME
  first=`echo $MODULE_VENDOR|cut -c1|tr [a-z] [A-Z]`
  second=`echo $MODULE_VENDOR|cut -c2-`
  MODULE_VENDOR=$first$second

  MODULE_NAME="$(cut -d'_' -f2 <<<$MODULE)"
  # NAME MODULE CORRECTLY
  first=`echo $MODULE_NAME|cut -c1|tr [a-z] [A-Z]`
  second=`echo $MODULE_NAME|cut -c2-`
  MODULE_NAME=$first$second

  # CREATE DATABASE TABLES
  if [ -f "app/Frostbite/$MODULE_VENDOR/$MODULE_NAME/Data/_____${MODULE_NAME}DataCreator.php" ]; then
    echo "====================================================="
    echo "Creating data tables for: $MODULE_VENDOR/$MODULE_NAME"
    php artisan migrate --path="app/Frostbite/$MODULE_VENDOR/$MODULE_NAME/Data/_____${MODULE_NAME}DataCreator.php"
  fi

  # SEED DATABASE TABLES
  if [ -f "app/Frostbite/$MODULE_VENDOR/$MODULE_NAME/Data/${MODULE_NAME}DataSeeder.php" ]; then
    echo "Seeding data tables for: $MODULE_VENDOR/$MODULE_NAME"
    php artisan db:seed --class=\\App\\Frostbite\\${MODULE_VENDOR}\\${MODULE_NAME}\\Data\\${MODULE_NAME}DataSeeder
  fi

  if [ -f "app/Frostbite/$MODULE_VENDOR/$MODULE_NAME/Data/${MODULE_NAME}DataSeeder01.php" ]; then
    echo "Seeding data tables for: $MODULE_VENDOR/$MODULE_NAME"
    php artisan db:seed --class=\\App\\Frostbite\\${MODULE_VENDOR}\\${MODULE_NAME}\\Data\\${MODULE_NAME}DataSeeder01
  fi

  if [ -f "app/Frostbite/$MODULE_VENDOR/$MODULE_NAME/Data/${MODULE_NAME}DataSeeder02.php" ]; then
    echo "Seeding data tables for: $MODULE_VENDOR/$MODULE_NAME"
    php artisan db:seed --class=\\App\\Frostbite\\${MODULE_VENDOR}\\${MODULE_NAME}\\Data\\${MODULE_NAME}DataSeeder02
  fi

  if [ -f "app/Frostbite/$MODULE_VENDOR/$MODULE_NAME/Data/${MODULE_NAME}DataSeeder03.php" ]; then
    echo "Seeding data tables for: $MODULE_VENDOR/$MODULE_NAME"
    php artisan db:seed --class=\\App\\Frostbite\\${MODULE_VENDOR}\\${MODULE_NAME}\\Data\\${MODULE_NAME}DataSeeder03
  fi

  if [ -f "app/Frostbite/$MODULE_VENDOR/$MODULE_NAME/Data/${MODULE_NAME}DataSeeder04.php" ]; then
    echo "Seeding data tables for: $MODULE_VENDOR/$MODULE_NAME"
    php artisan db:seed --class=\\App\\Frostbite\\${MODULE_VENDOR}\\${MODULE_NAME}\\Data\\${MODULE_NAME}DataSeeder04
  fi

  if [ -f "app/Frostbite/$MODULE_VENDOR/$MODULE_NAME/Data/${MODULE_NAME}DataSeeder05.php" ]; then
    echo "Seeding data tables for: $MODULE_VENDOR/$MODULE_NAME"
    php artisan db:seed --class=\\App\\Frostbite\\${MODULE_VENDOR}\\${MODULE_NAME}\\Data\\${MODULE_NAME}DataSeeder05
  fi

  if [ -f "app/Frostbite/$MODULE_VENDOR/$MODULE_NAME/Data/${MODULE_NAME}DataSeeder06.php" ]; then
    echo "Seeding data tables for: $MODULE_VENDOR/$MODULE_NAME"
    php artisan db:seed --class=\\App\\Frostbite\\${MODULE_VENDOR}\\${MODULE_NAME}\\Data\\${MODULE_NAME}DataSeeder06
  fi

  if [ -f "app/Frostbite/$MODULE_VENDOR/$MODULE_NAME/Data/${MODULE_NAME}DataSeeder07.php" ]; then
    echo "Seeding data tables for: $MODULE_VENDOR/$MODULE_NAME"
    php artisan db:seed --class=\\App\\Frostbite\\${MODULE_VENDOR}\\${MODULE_NAME}\\Data\\${MODULE_NAME}DataSeeder07
  fi

  if [ -f "app/Frostbite/$MODULE_VENDOR/$MODULE_NAME/Data/${MODULE_NAME}DataSeeder08.php" ]; then
    echo "Seeding data tables for: $MODULE_VENDOR/$MODULE_NAME"
    php artisan db:seed --class=\\App\\Frostbite\\${MODULE_VENDOR}\\${MODULE_NAME}\\Data\\${MODULE_NAME}DataSeeder08
  fi

  if [ -f "app/Frostbite/$MODULE_VENDOR/$MODULE_NAME/Data/${MODULE_NAME}DataSeeder09.php" ]; then
    echo "Seeding data tables for: $MODULE_VENDOR/$MODULE_NAME"
    php artisan db:seed --class=\\App\\Frostbite\\${MODULE_VENDOR}\\${MODULE_NAME}\\Data\\${MODULE_NAME}DataSeeder09
  fi

  if [ -f "app/Frostbite/$MODULE_VENDOR/$MODULE_NAME/Data/${MODULE_NAME}DataSeeder10.php" ]; then
    echo "Seeding data tables for: $MODULE_VENDOR/$MODULE_NAME"
    php artisan db:seed --class=\\App\\Frostbite\\${MODULE_VENDOR}\\${MODULE_NAME}\\Data\\${MODULE_NAME}DataSeeder10
  fi

  if [ -f "app/Frostbite/$MODULE_VENDOR/$MODULE_NAME/Data/${MODULE_NAME}DataSeeder11.php" ]; then
    echo "Seeding data tables for: $MODULE_VENDOR/$MODULE_NAME"
    php artisan db:seed --class=\\App\\Frostbite\\${MODULE_VENDOR}\\${MODULE_NAME}\\Data\\${MODULE_NAME}DataSeeder11
  fi

  if [ -f "app/Frostbite/$MODULE_VENDOR/$MODULE_NAME/Data/${MODULE_NAME}DataSeeder12.php" ]; then
    echo "Seeding data tables for: $MODULE_VENDOR/$MODULE_NAME"
    php artisan db:seed --class=\\App\\Frostbite\\${MODULE_VENDOR}\\${MODULE_NAME}\\Data\\${MODULE_NAME}DataSeeder12
  fi

  if [ -f "app/Frostbite/$MODULE_VENDOR/$MODULE_NAME/Data/${MODULE_NAME}DataSeeder13.php" ]; then
    echo "Seeding data tables for: $MODULE_VENDOR/$MODULE_NAME"
    php artisan db:seed --class=\\App\\Frostbite\\${MODULE_VENDOR}\\${MODULE_NAME}\\Data\\${MODULE_NAME}DataSeeder13
  fi

  if [ -f "app/Frostbite/$MODULE_VENDOR/$MODULE_NAME/Data/${MODULE_NAME}DataSeeder14.php" ]; then
    echo "Seeding data tables for: $MODULE_VENDOR/$MODULE_NAME"
    php artisan db:seed --class=\\App\\Frostbite\\${MODULE_VENDOR}\\${MODULE_NAME}\\Data\\${MODULE_NAME}DataSeeder14
  fi

  if [ -f "app/Frostbite/$MODULE_VENDOR/$MODULE_NAME/Data/${MODULE_NAME}DataSeeder15.php" ]; then
    echo "Seeding data tables for: $MODULE_VENDOR/$MODULE_NAME"
    php artisan db:seed --class=\\App\\Frostbite\\${MODULE_VENDOR}\\${MODULE_NAME}\\Data\\${MODULE_NAME}DataSeeder15
  fi

  if [ -f "app/Frostbite/$MODULE_VENDOR/$MODULE_NAME/Data/${MODULE_NAME}DataSeeder16.php" ]; then
    echo "Seeding data tables for: $MODULE_VENDOR/$MODULE_NAME"
    php artisan db:seed --class=\\App\\Frostbite\\${MODULE_VENDOR}\\${MODULE_NAME}\\Data\\${MODULE_NAME}DataSeeder16
  fi

  if [ -f "app/Frostbite/$MODULE_VENDOR/$MODULE_NAME/Data/${MODULE_NAME}DataSeeder17.php" ]; then
    echo "Seeding data tables for: $MODULE_VENDOR/$MODULE_NAME"
    php artisan db:seed --class=\\App\\Frostbite\\${MODULE_VENDOR}\\${MODULE_NAME}\\Data\\${MODULE_NAME}DataSeeder17
  fi

  if [ -f "app/Frostbite/$MODULE_VENDOR/$MODULE_NAME/Data/${MODULE_NAME}DataSeeder18.php" ]; then
    echo "Seeding data tables for: $MODULE_VENDOR/$MODULE_NAME"
    php artisan db:seed --class=\\App\\Frostbite\\${MODULE_VENDOR}\\${MODULE_NAME}\\Data\\${MODULE_NAME}DataSeeder18
  fi

  if [ -f "app/Frostbite/$MODULE_VENDOR/$MODULE_NAME/Data/${MODULE_NAME}DataSeeder19.php" ]; then
    echo "Seeding data tables for: $MODULE_VENDOR/$MODULE_NAME"
    php artisan db:seed --class=\\App\\Frostbite\\${MODULE_VENDOR}\\${MODULE_NAME}\\Data\\${MODULE_NAME}DataSeeder19
  fi

  if [ -f "app/Frostbite/$MODULE_VENDOR/$MODULE_NAME/Data/${MODULE_NAME}DataSeeder20.php" ]; then
    echo "Seeding data tables for: $MODULE_VENDOR/$MODULE_NAME"
    php artisan db:seed --class=\\App\\Frostbite\\${MODULE_VENDOR}\\${MODULE_NAME}\\Data\\${MODULE_NAME}DataSeeder20
  fi

  # ADD MENU TO SYSTEM
  if [ -f "app/Frostbite/$MODULE_VENDOR/$MODULE_NAME/Data/${MODULE_NAME}DataMenu.php" ]; then
    echo "Seeding menu information for: $MODULE_VENDOR/$MODULE_NAME"
    php artisan db:seed --class=\\App\\Frostbite\\${MODULE_VENDOR}\\${MODULE_NAME}\\Data\\${MODULE_NAME}DataMenu
  fi
done <app/Frostbite/frostbite.config
