#!/usr/bin/env bash

red='\e[1;31m%s\e[0m\n'
green='\e[1;32m%s\e[0m\n'
yellow='\e[1;33m%s\e[0m\n'
blue='\e[1;34m%s\e[0m\n'
magenta='\e[1;35m%s\e[0m\n'
cyan='\e[1;36m%s\e[0m\n'

printf "$green" "eBot configuration script"

source .env
echo "Patching ./etc/eBotSocket/config.ini"
cp ./etc/eBotSocket/config.ini ./etc/eBotSocket/config.ini.bak
sed -i "s/MYSQL_IP =.*/MYSQL_IP = \"mysqldb\"/g" ./etc/eBotSocket/config.ini
sed -i "s/MYSQL_PASS =.*/MYSQL_PASS = \"$MYSQL_PASSWORD\"/g" ./etc/eBotSocket/config.ini
sed -i "s/MYSQL_BASE =.*/MYSQL_BASE = \"$MYSQL_DATABASE\"/g" ./etc/eBotSocket/config.ini
sed -i "s/MYSQL_BASE =.*/MYSQL_BASE = \"$MYSQL_DATABASE\"/g" ./etc/eBotSocket/config.ini
sed -i "s/COMMAND_STOP_DISABLED =.*/COMMAND_STOP_DISABLED = $COMMAND_STOP_DISABLED/g" ./etc/eBotSocket/config.ini
sed -i "s#LOG_ADDRESS_SERVER =.*#LOG_ADDRESS_SERVER = \"$LOG_ADDRESS_SERVER\"#g" ./etc/eBotSocket/config.ini
sed -i "s/WEBSOCKET_SECRET_KEY =.*/WEBSOCKET_SECRET_KEY = \"$WEBSOCKET_SECRET_KEY\"/g" ./etc/eBotSocket/config.ini
sed -i "s/REDIS_HOST =.*/REDIS_HOST = \"redis\"/g" ./etc/eBotSocket/config.ini
sed -i "s/BOT_IP =.*/BOT_IP = \"0.0.0.0\"/g" ./etc/eBotSocket/config.ini


echo "Patching ./etc/eBotWeb/app_user.yml"
cp ./etc/eBotWeb/app_user.yml ./etc/eBotWeb/app_user.yml.bak
sed -i "s|log_match:.*|log_match: /app/ebot-logs/log_match|" ./etc/eBotWeb/app_user.yml
sed -i "s|log_match_admin:.*|log_match_admin: /app/ebot-logs/log_match_admin|" ./etc/eBotWeb/app_user.yml
sed -i "s|demo_path:.*|demo_path: /app/ebot-demos|" ./etc/eBotWeb/app_user.yml
sed -i "s|websocket_secret_key:.*|websocket_secret_key: $WEBSOCKET_SECRET_KEY|" ./etc/eBotWeb/app_user.yml
sed -i "s|ebot_ip:.*|ebot_ip: $EBOT_IP|g" ./etc/eBotWeb/app_user.yml
sed -i "s|websocket_url:.*|websocket_url: $WEBSOCKET_URL|g" ./etc/eBotWeb/app_user.yml

echo "Patching ./etc/eBotWeb/database.yml"
cp ./etc/eBotWeb/databases.yml ./etc/eBotWeb/databases.yml.bak
sed -i "s|dsn:.*|dsn: \"mysql:host=mysqldb;dbname=${MYSQL_DATABASE}\"|" ./etc/eBotWeb/databases.yml
sed -i "s|username:.*|username: ${MYSQL_USER}|" ./etc/eBotWeb/databases.yml
sed -i "s|password:.*|password: ${MYSQL_PASSWORD}|" ./etc/eBotWeb/databases.yml
