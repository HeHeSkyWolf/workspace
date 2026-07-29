# Workspace

Self-hosted development workspace infrastructure running in Docker containers.

## Services

| Service | Description | Image |
|---------|-------------|-------|
| **nginx** | Reverse proxy with virtual host routing | `nginx:1.30.4-alpine` |
| **Gogs** | Self-hosted Git service ([gogs.io](https://gogs.io/)) | `gogs/gogs:0.14.3` |

## Quick Start

```bash
# Set up gogs configs
cp gogs/.env.example gogs/.env

# Set up nginx configs
cp nginx/.env.example nginx/.env

./startup.sh
```
