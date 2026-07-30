# App-Proxy

Internal reverse proxy (nginx) that routes to backend services by hostname over the `workspace-net` Docker network.

## Routing

| Hostname | Backend | Port |
|----------|---------|------|
| `vaultwarden.localhost` | `vaultwarden:80` | 443 (HTTPS) |
| `gogs.localhost` | `gogs:3000` | 443 (HTTPS) |
| `localhost` | static page | 443 (HTTPS) |

Plain HTTP on port 80 only issues a `301` redirect to HTTPS. All service configs live in `nginx/conf/*.conf`.

## Prerequisites

- Docker + Docker Compose
- The `workspace-net` network (created by `../scripts/startup.sh`)
- The backend containers (`vaultwarden`, `gogs`) running on `workspace-net`
- A TLS certificate + key (self-signed or Let's Encrypt) mounted at `/etc/nginx/ssl/`

## Setup

### 1. Configure environment

```bash
cp .env.example .env
```

### 2. Generate a self-signed certificate

Both this service and the gateway mount `nginx-certs/` as `/etc/nginx/ssl`. Generate once and copy into both:

```bash
openssl req -x509 -nodes -newkey rsa:2048 -days 365 \
  -keyout nginx-certs/localhost.key \
  -out nginx-certs/localhost.crt \
  -subj "/CN=*.localhost"
```

> The `nginx-certs/` directory is git-ignored (`**/nginx-certs/`) — do not commit private keys.

For Let's Encrypt instead, see [Using Let's Encrypt](#using-lets-encrypt).

### 3. Start

```bash
docker-compose up -d
```

## Notes

- Git smart HTTP (push/pull) works through this proxy — `client_max_body_size 0`, `proxy_buffering off`, and `proxy_request_buffering off` are already set for the gogs route.
- The gateway forwards to this container over HTTPS (`https://app-proxy:443`) using SNI, so the hostname in the `Host` header must match a `server_name` here.
