# Production Deployment

## Quick Start

1. Set environment variables:
```bash
export SECRET_KEY_BASE=$(rails secret)
export DATABASE_URL=postgresql://user:pass@localhost/db
```

2. Setup database:
```bash
RAILS_ENV=production rails db:migrate
```

3. Run:
```bash
RAILS_ENV=production rails server
```

## Docker

### Production
```bash
# Set secret key
export SECRET_KEY_BASE=$(openssl rand -hex 64)

# Start services
docker-compose up -d

# View logs
docker-compose logs -f web

# Stop
docker-compose down
```

### Development
```bash
docker-compose -f docker-compose.dev.yml up
```

### Quick Start Script
```bash
./docker-start.sh
```

## Docker Commands

```bash
# Build image
docker-compose build

# Run migrations
docker-compose exec web rails db:migrate

# Open console
docker-compose exec web rails console

# View logs
docker-compose logs -f

# Restart
docker-compose restart web

# Clean up
docker-compose down -v
```

## Environment Variables

Create `.env` file:
```bash
SECRET_KEY_BASE=your_secret_key
DATABASE_URL=postgresql://ror_app:password@db:5432/ror_app_production
RAILS_ENV=production
```

## Security Checklist

✅ SQL injection protected
✅ CSRF enabled  
✅ Session fixation prevented
✅ Authorization on all actions
✅ Password hashing (bcrypt)

## Performance

✅ Database indexes
✅ Eager loading
✅ Pagination
✅ Thread-safe counters
