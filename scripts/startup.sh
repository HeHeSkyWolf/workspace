#!/bin/bash

echo "Build the Workspace Network"
docker network inspect workspace-net >/dev/null 2>&1 || docker network create workspace-net

echo "Starting Gateway Nginx"
cd ../gateway && docker-compose up -d && cd ..

echo "Starting App-Proxy Nginx"
cd app-proxy && docker-compose up -d && cd ..

echo "Starting Gogs"
cd gogs && docker-compose up -d && cd ..

echo "Starting Vaultwarden"
cd vaultwarden && docker-compose up -d && cd ..

echo "Starting Linkding"
cd linkding && docker-compose up -d && cd ..