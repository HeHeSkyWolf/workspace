#!/bin/bash

echo "Build the Workplace Network"
docker network inspect workplace-net >/dev/null 2>&1 || docker network create workplace-net

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