# Docker Quick Start

## Development

```bash
docker-compose -f docker-compose.dev.yml up
```

Visit: http://localhost:3000

## Production

```bash
# Generate secret
export SECRET_KEY_BASE=$(openssl rand -hex 64)

# Start
docker-compose up -d

# View logs
docker-compose logs -f web
```

## Useful Commands

```bash
# Build
docker-compose build

# Migrations
docker-compose exec web rails db:migrate

# Console
docker-compose exec web rails console

# Stop
docker-compose down

# Clean up
docker-compose down -v
```
