# Gogs

Self-hosted Git service ([gogs.io](https://gogs.io/)) running `gogs/gogs:${GOGS_TAG}`.

## Ports

- `3000` — Web UI (exposed on the network, proxied via gateway/app-proxy)
- `22` — SSH for Git operations (e.g. `git clone ssh://git@host:22/...`)

## Data

All state is persisted in `./gogs-data`:

- SQLite database
- App config
- Repository data

## Setup

```bash
cp .env.example .env
```

Set `GOGS_SECURITY_SECRET_KEY` in `.env` to a random UUID (generate one at [uuidgenerator.net](https://www.uuidgenerator.net/)).

## Start

```bash
docker-compose up -d
```
