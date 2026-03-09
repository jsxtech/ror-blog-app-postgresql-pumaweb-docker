#!/bin/bash
set -e

echo "🐳 Starting RorApp with Docker Compose..."

# Generate secret if not set
if [ -z "$SECRET_KEY_BASE" ]; then
  echo "⚠️  SECRET_KEY_BASE not set. Generating one..."
  export SECRET_KEY_BASE=$(openssl rand -hex 64)
fi

# Start services
docker-compose up -d

echo "✅ Services started!"
echo "📝 Web: http://localhost:3000"
echo "🗄️  Database: postgresql://ror_app:password@localhost:5432/ror_app_production"
echo ""
echo "View logs: docker-compose logs -f"
echo "Stop: docker-compose down"
