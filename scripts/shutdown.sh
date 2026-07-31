#!/bin/bash

echo "Stopping Gogs"
cd ../gogs && docker-compose down && cd ..

echo "Stopping App-Proxy Nginx"
cd app-proxy && docker-compose down && cd ..

echo "Stopping Gateway Nginx"
cd gateway && docker-compose down && cd ..

echo "All containers stopped."
