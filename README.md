# Minecraft Modpack Server — Docker

A containerized Minecraft modpack server built with Docker and automated via GitHub Actions CI/CD pipeline.

## Requirements

- Docker 20.10+
- Docker Compose 2.0+
- At least 4GB of free RAM

## Quick Start

**Using Docker Compose (recommended):**

```bash
git clone https://github.com/jstin9/minecraft-server-docker.git
cd minecraft-server-docker
docker compose up -d
```

**Using Docker directly:**

```bash
docker run -d \
  -p 25565:25565 \
  -p 24454:24454/udp \
  -v mc-data:/data \
  jstn9/minecraft-server:latest
```

Server will be available at `localhost:25565` after startup. First launch takes several minutes — the modpack is downloaded automatically.

## Configuration

All settings are passed as environment variables. Override them in `docker-compose.yml` or via `-e` flag.

| Variable | Default | Description |
|---|---|---|
| `EULA` | `TRUE` | Minecraft End User License Agreement |
| `MEMORY` | `4G` | Java heap size (e.g. `2G`, `6G`) |
| `MODPACK_PLATFORM` | `MODRINTH` | Modpack platform: `MODRINTH`, `AUTO_CURSEFORGE` |
| `MODRINTH_MODPACK` | `fabulously-optimized` | Modpack slug from modrinth.com |
| `MODRINTH_VERSION` | latest stable | Specific modpack version |
| `MODRINTH_PROJECTS` | — | Extra mods to add (`slug` or `slug:version`) |
| `MODRINTH_EXCLUDE_FILES` | — | Mods to exclude from the modpack |

**Example — changing the modpack:**

```yaml
environment:
  MODPACK_PLATFORM: "MODRINTH"
  MODRINTH_MODPACK: "all-the-mods-9"
  MEMORY: 6G
```

## Data Persistence

World data, player data, and server configs are stored in a named Docker volume `mc-data`. Data persists across container restarts and image updates.

To back up your world:

```bash
docker run --rm \
  -v mc-data:/data \
  -v $(pwd):/backup \
  ubuntu tar czf /backup/world-backup.tar.gz /data/world
```

To remove all data and start fresh:

```bash
docker compose down -v
```

## Ports

| Port | Protocol | Description |
|---|---|---|
| `25565` | TCP | Minecraft game port |
| `24454` | UDP | Simple Voice Chat mod |

## CI/CD

The repository includes a GitHub Actions pipeline that runs on every push to `main`:

1. Validates `docker-compose.yml` syntax
2. Lints `Dockerfile` with hadolint
3. Builds the Docker image and pushes it to Docker Hub

## Project Structure

```
minecraft-server-docker/
├── .github/
│   └── workflows/
│       └── ci.yml          # GitHub Actions pipeline
├── Dockerfile              # image definition
├── docker-compose.yml      # local setup and example configuration
└── README.md
```

## Based On

- [itzg/minecraft-server](https://github.com/itzg/docker-minecraft-server) — the base Docker image
- [Fabulously Optimized](https://modrinth.com/modpack/fabulously-optimized) — default modpack
