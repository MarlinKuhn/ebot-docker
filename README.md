# eBot Docker

## Overview
It is a containerized version of eBot, which is a full managed server-bot written in PHP and nodeJS. eBot features easy match creation and tons of player and matchstats. Once it's setup, using the eBot is simple and fast.

## How to run it
### 1. Install Docker

### 2. Configure
Run the setup script to configure the eBot. You can change the configuration in the setup.sh file.
```bash
docker run -v ./:/data -w /app -it gymitpro/ebot-configure:latest ./setup.sh
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
docker buildx build --platform linux/amd64,linux/arm64 -t gymitpro/ebot-logs-receiver:latest --push .
cd ../ebot-socket
docker buildx build --platform linux/amd64,linux/arm64 -t gymitpro/ebot-socket:latest --push .
cd ../ebot-web
docker buildx build --platform linux/amd64,linux/arm64 -t gymitpro/ebot-web:latest --push .
cd ../ebot-configure
docker buildx build --platform linux/amd64,linux/arm64 -t gymitpro/ebot-configure:latest --push .
```
