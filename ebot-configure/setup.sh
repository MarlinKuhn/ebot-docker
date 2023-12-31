#!/usr/bin/env bash

red='\e[1;31m%s\e[0m\n'
green='\e[1;32m%s\e[0m\n'
yellow='\e[1;33m%s\e[0m\n'
blue='\e[1;34m%s\e[0m\n'
magenta='\e[1;35m%s\e[0m\n'
cyan='\e[1;36m%s\e[0m\n'

function yesNo() {
    while true; do
        read -p "$1 [y/n]: " yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

function ask_with_default() {
    local prompt="$1"
    local default_value="$2"

    read -p "${prompt} [current: ${default_value}]: " input_value
    if [[ -z "$input_value" ]]; then
        echo "$default_value"
    else
        echo "$input_value"
    fi
}


printf "$green" "eBot setup script"

function generatePassword() {
    openssl rand -hex 16
}

printf "$magenta" "Generating new websocket secret"
NEW_WEBSOCKET_SECRET_KEY=$(generatePassword)
sed -i -e "s#WEBSOCKET_SECRET_KEY=.*#WEBSOCKET_SECRET_KEY=${NEW_WEBSOCKET_SECRET_KEY}#g" \
    "$(dirname "$0")/.env"

printf "$green" "MySQL confuguration"
if yesNo "Do you have an existing MySQL database?"; then
  printf "$red" "If you have an existing MySQL database, please put the /data folder inside the current folder"
  if yesNo "Did you copy the data directory?"; then
    if [ -d "/data/data" ]; then
      printf "$green" "Existing data folder found!"
    else
      printf "$red" "Folder not found!"
      exit 1
    fi
  fi
fi

if [ -d "/data/data" ]; then
    printf "$yellow" "You have to provide the existing mysql root password and the mysql user password."
    NEW_MYSQL_ROOT_PASSWORD=$(ask_with_default "Existing MySQL root password" "")
    NEW_MYSQL_PASSWORD=$(ask_with_default "Existing MySQL user password" "")
    DATABASE_EXISTS=1
else
    printf "$magenta" "Creating new mysql password"
    NEW_MYSQL_ROOT_PASSWORD=$(generatePassword)
    NEW_MYSQL_PASSWORD=$(generatePassword)
    NEW_MYSQL_ROOT_PASSWORD=$(ask_with_default "MySQL root password" $NEW_MYSQL_ROOT_PASSWORD)
    NEW_MYSQL_PASSWORD=$(ask_with_default "MySQL user password" $NEW_MYSQL_PASSWORD)
    printf "$green" "ROOT PASSWORD: $NEW_MYSQL_ROOT_PASSWORD"
    printf "$green" "USER PASSWORD: $NEW_MYSQL_PASSWORD"
    DATABASE_EXISTS=0
fi

sed -i -e "s#MYSQL_ROOT_PASSWORD=.*#MYSQL_ROOT_PASSWORD=${NEW_MYSQL_ROOT_PASSWORD}#g" \
    -e "s#MYSQL_PASSWORD=.*#MYSQL_PASSWORD=${NEW_MYSQL_PASSWORD}#g" \
    -e "s#DATABASE_EXISTS=.*#DATABASE_EXISTS=${DATABASE_EXISTS}#g" \
    "$(dirname "$0")/.env"

source .env

printf "$green" "Now doing the default configuration of eBot web"

printf "$yellow" "eBot Web login: $EBOT_ADMIN_LOGIN"
EBOT_ADMIN_PASSWORD=$(ask_with_default "eBot Web password" $EBOT_ADMIN_PASSWORD)
if [ "$DATABASE_EXISTS" != "1" ]; then
  EBOT_ADMIN_EMAIL=$(ask_with_default "eBot Web email" $EBOT_ADMIN_EMAIL)
else
  printf "$yellow" "eBot Web email cannot be changed because the database already exists!"
fi

sed -i -e "s#EBOT_ADMIN_PASSWORD=.*#EBOT_ADMIN_PASSWORD=${EBOT_ADMIN_PASSWORD}#g" \
    -e "s#EBOT_ADMIN_EMAIL=.*#EBOT_ADMIN_EMAIL=${EBOT_ADMIN_EMAIL}#g" \
    "$(dirname "$0")/.env"

printf "$green" "Now configuring IP"
echo "We need to know on which IP the eBot will run, please fill in the IP of the eBot (public or lan) (format 192.168.X.X)"
EBOT_IP=$(ask_with_default "eBot IP" $EBOT_IP)
LOG_ADDRESS_SERVER=http://${EBOT_IP}:12345

echo "Finally, eBot now supports SSL, and then the customization of the domain name / URL for the websocket."
echo "This SSL configuration must be done on your side (using letsencrypt by example)"
if yesNo "Will you be using SSL ?"
then
   WEBSOCKET_URL=$(ask_with_default "What will you be using as domain / url for the websocket server" $WEBSOCKET_URL)
   sed -i -e "s#WEBSOCKET_URL=.*#WEBSOCKET_URL=${WEBSOCKET_URL}#g" \
       "$(dirname "$0")/.env"

   echo "Don't forget to create a reverse proxy for the websocket server, that normally listen on 12360"
   sleep 5
else
    if [ "$WEBSOCKET_URL" = "replaceme" ]
    then
        echo "Replacing WEBSOCKET_URL with EBOT_IP value"
        sed -i -e "s#WEBSOCKET_URL=.*#WEBSOCKET_URL=http://${EBOT_IP}:12360#g" \
            "$(dirname "$0")/.env"
    fi
fi

sed -i -e "s#LOG_ADDRESS_SERVER=.*#LOG_ADDRESS_SERVER=${LOG_ADDRESS_SERVER}#g" \
    -e "s#EBOT_IP=.*#EBOT_IP=${EBOT_IP}#g" \
    "$(dirname "$0")/.env"

./configure.sh
./copy_data.sh

printf "$green" "eBot installation done!"
printf "$yellow" "You can start the eBot with the following command:"
printf "$yellow" "docker-compose up -d"
echo ""
printf "$yellow" "You can stop the eBot with the following command:"
printf "$yellow" "docker-compose down"
