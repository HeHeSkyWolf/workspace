# Vaultwarden

Lightweight self-hosted password manager, compatible with Bitwarden clients. Runs `vaultwarden/server:${VAULTWARDEN_TAG}`.

## Configuration

Key environment variables (set in `docker-compose.yml`):

- `WEBSOCKET_ENABLED=true` — Enables WebSocket notifications for live sync
- `SIGNUPS_ALLOWED=true` — Allows new account sign-ups (disable after initial setup)
- `DOMAIN=https://vaultwarden.localhost` — Public base URL; must match how the service is reached through the proxy

## Data

All state (SQLite DB, attachments, config) is persisted in `./vw-data/`.

## Setup

```bash
cp .env.example .env
```

Set `VAULTWARDEN_TAG` in `.env` to the desired image tag.

## Start

```bash
docker-compose up -d
```
