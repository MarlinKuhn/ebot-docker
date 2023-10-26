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


printf "$magenta" "Generating new mysql password"
NEW_MYSQL_ROOT_PASSWORD=$(generatePassword)
NEW_MYSQL_PASSWORD=$(generatePassword)
sed -i -e "s#MYSQL_ROOT_PASSWORD=.*#MYSQL_ROOT_PASSWORD=${NEW_MYSQL_ROOT_PASSWORD}#g" \
    -e "s#MYSQL_PASSWORD=.*#MYSQL_PASSWORD=${NEW_MYSQL_PASSWORD}#g" \
    "$(dirname "$0")/.env"

source .env

printf "$green" "Now doing the default configuration of eBot web"

EBOT_ADMIN_LOGIN=$(ask_with_default "eBot Web login" $EBOT_ADMIN_LOGIN)
EBOT_ADMIN_PASSWORD=$(ask_with_default "eBot Web password" $EBOT_ADMIN_PASSWORD)
EBOT_ADMIN_EMAIL=$(ask_with_default "eBot Web email" $EBOT_ADMIN_EMAIL)

sed -i -e "s#EBOT_ADMIN_LOGIN=.*#EBOT_ADMIN_LOGIN=${EBOT_ADMIN_LOGIN}#g" \
    -e "s#EBOT_ADMIN_PASSWORD=.*#EBOT_ADMIN_PASSWORD=${EBOT_ADMIN_PASSWORD}#g" \
    -e "s#EBOT_ADMIN_EMAIL=.*#EBOT_ADMIN_EMAIL=${EBOT_ADMIN_EMAIL}#g" \
    "$(dirname "$0")/.env"

printf "$green" "Now configuring IP"
echo "We need to know on which IP the server will run, please fill in the IP of the server (public or lan) (format 192.168.X.X)"
EBOT_IP=$(ask_with_default "Log address server" $EBOT_IP)
LOG_ADDRESS_SERVER=http://${EBOT_IP}:12345

sed -i -e "s#LOG_ADDRESS_SERVER=.*#LOG_ADDRESS_SERVER=${LOG_ADDRESS_SERVER}#g" \
    -e "s#EBOT_IP=.*#EBOT_IP=${EBOT_IP}#g" \
    "$(dirname "$0")/.env"

./configure.sh
