#!/usr/bin/env bash

# eBot configuration
rf -rf /data/etc/
mkdir -p /data/etc/
cp -r ./etc/ /data/
cp .env /data/.env

# eBot folders
mkdir -p /data/ebot-demos/
mkdir -p /data/ebot-logs/log_match
mkdir -p /data/ebot-logs/log_match_admin
mkdir -p /data/data/

# eBot docker-compose
cp docker-compose.yml /data/docker-compose.yml

