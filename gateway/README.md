# Gateway

Edge reverse proxy that routes external traffic to the internal `app-proxy` service. Runs on `nginx:${NGINX_TAG}`.

## How it works

Incoming requests hit the gateway on a host port (e.g. `33021`) and are proxied to `app-proxy` with the target service hostname set (e.g. `gogs.localhost`). The `app-proxy` service then routes to the backend container.

## Files

- `docker-compose.yml` — Nginx container definition
- `nginx/conf/` — Site configs, one file per exposed service (e.g. `gogs.conf`)
- `.env` — Environment overrides (copy from `.env.example`)

## Setup

```bash
cp .env.example .env
```

## Start

```bash
docker-compose up -d
```
