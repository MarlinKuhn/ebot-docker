# eBot Docker

## Overview
It is a containerized version of eBot, which is a full managed server-bot written in PHP and nodeJS. eBot features easy match creation and tons of player and matchstats. Once it's setup, using the eBot is simple and fast.

## How to run it
### 1. Install Docker

### 2. Configure
Run the setup script to configure the eBot. You can change the configuration in the setup.sh file.
```bash
docker run -v ./:/data -it --rm gymitpro/ebot-configure:v1.0
```

### 3. Run
Run the eBot with the following command:
```bash
docker-compose up -d
```
Or under linux/mac
```bash
docker compose up -d
```

# Build images
Not relevant for running

```bash
cd ebot-logs-receiver
docker buildx build --platform linux/amd64,linux/arm64 -t gymitpro/ebot-logs-receiver:v1.0 --push .
cd ../ebot-socket
docker buildx build --platform linux/amd64,linux/arm64 -t gymitpro/ebot-socket:v1.0 --push .
cd ../ebot-web
docker buildx build --platform linux/amd64,linux/arm64 -t gymitpro/ebot-web:v1.0 --push .
```

# Update configure:
Change version in docker-compose.yml

```bash
cd ../ebot-configure
docker buildx build --platform linux/amd64,linux/arm64 -t gymitpro/ebot-configure:v1.0 --push .
```