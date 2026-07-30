# Workspace

Self-hosted development workspace infrastructure running in Docker containers.

## Services

| Service | Description | Image |
|---------|-------------|-------|
| **gateway** | Edge reverse proxy routes to app-proxy | `nginx:1.30.4-alpine` |
| **app-proxy** | Internal reverse proxy, routes to backend services by hostname | `nginx:1.30.4-alpine` |
| **Gogs** | Self-hosted Git service ([gogs.io](https://gogs.io/)) | `gogs/gogs:0.14.3` |

## Quick Start

```bash
# Set up configs
cp app-proxy/.env.example app-proxy/.env
cp gateway/.env.example gateway/.env
cp gogs/.env.example gogs/.env

# Start all services
./startup.sh
```
