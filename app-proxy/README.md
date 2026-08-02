# App-Proxy

Internal reverse proxy (nginx) that routes to backend services by hostname over the `workplace-net` Docker network.

## Routing

| Hostname | Backend | Port |
|----------|---------|------|
| `vaultwarden.localhost` | `vaultwarden:80` | 443 (HTTPS) |
| `gogs.localhost` | `gogs:3000` | 443 (HTTPS) |
| `localhost` | static page | 443 (HTTPS) |

Plain HTTP on port 80 only issues a `301` redirect to HTTPS. All service configs live in `nginx/conf/*.conf`.

## Prerequisites

- Docker + Docker Compose
- The `workplace-net` network (created by `../scripts/startup.sh`)
- The backend containers (`vaultwarden`, `gogs`) running on `workplace-net`
- A TLS certificate + key (self-signed or Let's Encrypt) mounted at `/etc/nginx/ssl/`

## Setup

### 1. Configure environment

```bash
cp .env.example .env
```

### 2. Generate a self-signed certificate

Both this service and the gateway mount `nginx-certs/` as `/etc/nginx/ssl`. Generate once and copy into both:

```bash
mkdir -p nginx-certs
openssl req -x509 -nodes -newkey rsa:2048 -days 365 \
  -keyout nginx-certs/localhost.key \
  -out nginx-certs/localhost.crt \
  -subj "/CN=*.localhost"
cp nginx-certs/localhost.crt nginx-certs/localhost.key ../gateway/nginx-certs/
```

> The `nginx-certs/` directory is git-ignored (`**/nginx-certs/`) — do not commit private keys.

For Let's Encrypt instead, see [Using Let's Encrypt](#using-lets-encrypt).

### 3. Start

```bash
docker-compose up -d
```

Or via the workspace-wide script: `../scripts/startup.sh`.

## Access

- Vaultwarden: `https://vaultwarden.localhost/` (map `vaultwarden.localhost` to the host in your DNS/hosts file)
- Gogs via gateway: `http://<host>:33021/` — the gateway proxies to this container over HTTPS

## Using Let's Encrypt

Let's Encrypt only issues certificates for public domains (not `.localhost` or IPs). To use it:

1. Point a public domain (e.g. `vaultwarden.example.com`) at the machine and make port 80 reachable.
2. Issue the cert on the host:
   ```bash
   sudo certbot certonly --webroot -w /usr/share/nginx/html \
     -d vaultwarden.example.com -d gogs.example.com
   ```
3. Mount the certs into this container by adding to `docker-compose.yml`:
   ```yaml
   volumes:
     - /etc/letsencrypt:/etc/letsencrypt:ro
   ```
4. Update `server_name` and `ssl_certificate` paths in `nginx/conf/*.conf`:
   ```nginx
   server_name vaultwarden.example.com;
   ssl_certificate     /etc/letsencrypt/live/vaultwarden.example.com/fullchain.pem;
   ssl_certificate_key /etc/letsencrypt/live/vaultwarden.example.com/privkey.pem;
   ```
5. Set up auto-renewal with a reload hook:
   ```bash
   sudo certbot renew --deploy-hook "docker exec app-proxy nginx -s reload"
   ```

## Notes

- Git smart HTTP (push/pull) works through this proxy — `client_max_body_size 0`, `proxy_buffering off`, and `proxy_request_buffering off` are already set for the gogs route.
- The gateway forwards to this container over HTTPS (`https://app-proxy:443`) using SNI, so the hostname in the `Host` header must match a `server_name` here.
