#!/bin/bash

cd ..
php artisan iseed content_states,data_rows,data_types,menu_items,menus,permission_role,permissions,roles --force
