#!/bin/bash

curl -sLJO -H "Authorization: token 727993bc5e404384b86693d452517b97d2d74a3d" --user "jep-brianellis:Bellis@5121" "https://github.com/jep-capital-devs/app_core_laravel/archive/master.zip"

unzip app_core_laravel-master.zip

mv app_core_laravel-master/bin ../bin
mv app_core_laravel-master/bootstrap ../bootstrap
mv app_core_laravel-master/config ../config
mv app_core_laravel-master/database ../database
mv app_core_laravel-master/public ../public
mv app_core_laravel-master/routes ../routes
mv app_core_laravel-master/storage ../storage
mv app_core_laravel-master/tests ../tests
mv app_core_laravel-master/.editorconfig ../.editorconfig
mv app_core_laravel-master/artisan ../artisan
mv app_core_laravel-master/composer.json ../composer.json
mv app_core_laravel-master/composer.lock ../composer.lock
mv app_core_laravel-master/phpunit.xml ../phpunit.xml
mv app_core_laravel-master/server.php ../server.php

mv app_core_laravel-master/app/Console ../app/Console
mv app_core_laravel-master/app/Exceptions ../app/Exceptions
mv app_core_laravel-master/app/Http ../app/Http
mv app_core_laravel-master/app/Providers ../app/Providers
mv app_core_laravel-master/app/User.php ../app/User.php

mv app_core_laravel-master/app/Frostbite/FrostbiteServiceProvider.php ../app/Frostbite/FrostbiteServiceProvider.php
mv app_core_laravel-master/app/Frostbite/web.php ../app/Frostbite/web.php
mv app_core_laravel-master/app/Frostbite/admin.php ../app/Frostbite/admin.php
mv app_core_laravel-master/app/Frostbite/master.blade.php ../app/Frostbite/master.blade.php
rm -rf app_core_laravel-master app_core_laravel-master.zip
