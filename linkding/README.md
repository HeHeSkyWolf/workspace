# Linkding

Self-hosted bookmark manager ([github.com/sissbruecker/linkding](https://github.com/sissbruecker/linkding)). Runs `sissbruecker/linkding:${LINKDING_TAG}`.

## Configuration

Key environment variables (set in `.env`, passed through to the container in `docker-compose.yml`):

- `LD_CONTEXT_PATH` — Serve under a URL sub-path (e.g. `linkding/`, must end with `/`)
- `LD_SUPERUSER_NAME` / `LD_SUPERUSER_PASSWORD` — Initial superuser account (leave both empty to rely on proxy authentication)
- `LD_ENABLE_AUTH_PROXY` — Enables auth proxy support (e.g. Authelia) via `LD_AUTH_PROXY_USERNAME_HEADER`
- `LD_DISABLE_LOGIN_FORM` — Disables the login form to enforce OIDC/proxy authentication
- `LD_DISABLE_BACKGROUND_TASKS` — Disables background tasks (default `False`)
- `LD_DISABLE_URL_VALIDATION` — Disables URL validation for bookmarks (default `False`)

Database settings:

- `LD_DB_ENGINE` — `sqlite` (default) or `postgres`
- `LD_DB_DATABASE` / `LD_DB_USER` / `LD_DB_PASSWORD` / `LD_DB_HOST` / `LD_DB_PORT` / `LD_DB_OPTIONS` — PostgreSQL connection settings

## Data

All state (SQLite DB, bookmarks, settings) is persisted in `./data` (override with `LD_HOST_DATA_DIR`).

## Setup

```bash
cp .env.example .env
```

Set `LINKDING_TAG` in `.env` to the desired image tag.

## Start

```bash
docker-compose up -d
```

Linkding is exposed on the network on port `9090` and proxied via gateway/app-proxy.

## User Setup

```bash
docker-compose exec linkding python manage.py createsuperuser --username=joe --email=joe@example.com
```

This creates a superuser for you to log in.
