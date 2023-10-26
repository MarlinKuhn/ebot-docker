#!/bin/bash

php wait_for_db.php

# Check if the .installed file exists
if [ ! -f .installed ]; then

    cd eBot-CSGO-Web

    sleep 30

    php symfony cc

    if [ "$DATABASE_EXISTS" != "1" ]; then
      php symfony doctrine:build --all --no-confirmation
      php symfony guard:create-user --is-super-admin $EBOT_ADMIN_EMAIL $EBOT_ADMIN_LOGIN $EBOT_ADMIN_PASSWORD
    else
      php symfony guard:change-password $EBOT_ADMIN_LOGIN $EBOT_ADMIN_PASSWORD
    fi


    rm -rf web/installation

    cd ..

    touch .installed

    php-fpm
else
    echo "eBot Web is already installed. Skipping setup."
    cd eBot-CSGO-Web
    php symfony cc
    echo "Clearing cache"

    php-fpm
fi
