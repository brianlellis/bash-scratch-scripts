#!/bin/bash

cd ../app/Frostbite

#REMOVE ALL CURRENT MODULES
rm -R `ls -1 -d */`

# LOOP THROUGH EACH DEFINED MODULE IN frostbite.config
while read MODULE; do
  # SKIP COMMENTS
  [[ "$MODULE" =~ ^[[:space:]]*# ]] && continue

  MODULE_VENDOR="$(cut -d'_' -f1 <<<$MODULE)"
  MODULE_NAME="$(cut -d'_' -f2 <<<$MODULE)"

  # CAPTALIZE MODULE VENDOR NAME
  first=`echo $MODULE_VENDOR|cut -c1|tr [a-z] [A-Z]`
  second=`echo $MODULE_VENDOR|cut -c2-`
  MODULE_VENDOR=$first$second

  mkdir -p $MODULE_VENDOR
  cd $MODULE_VENDOR

  echo "=========================="
  echo "Installing module: $MODULE"
  curl -sLJO -H "Authorization: token 727993bc5e404384b86693d452517b97d2d74a3d" --user "jep-brianellis:Bellis@5121" "https://github.com/jep-capital-devs/module_$MODULE/archive/master.zip"

  # NAME MODULE CORRECTLY
  first=`echo $MODULE_NAME|cut -c1|tr [a-z] [A-Z]`
  second=`echo $MODULE_NAME|cut -c2-`
  MODULE_NAME=$first$second

  unzip module_$MODULE-master.zip && mv "module_$MODULE-master" $MODULE_NAME

  # SET UP CONFIGURATION FILE
  if [ -f "${MODULE_NAME}/config.php" ]; then
    cd $MODULE_NAME
    echo "Setting up Config files for: $MODULE_NAME";

    LOWER_NAME=`echo $MODULE_NAME|tr [A-Z] [a-z]`
    LOWER_VENDOR=`echo $MODULE_VENDOR|tr [A-Z] [a-z]`

    mv config.php ../../../../config/${LOWER_VENDOR}_${LOWER_NAME}.php
    cd ..
  fi

  # ZIPPED MODULE FROM SYSTEM
  rm module_$MODULE-master.zip

  cd ..
done <frostbite.config

# INSTALL DATA IF IN SYSTEM
cd ../../bin && sh data.sh
