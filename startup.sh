#!/bin/bash

echo "Build the Workplace Network"
docker network inspect workplace-net >/dev/null 2>&1 || docker network create workplace-net

echo "Starting Workplace Nginx"
cd nginx && docker-compose up -d && cd ..

echo "Starting Gogs"
cd gogs && docker-compose up -d && cd ..