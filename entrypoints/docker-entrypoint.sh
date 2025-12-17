#!/bin/sh

set -e

# Ensure database is ready
DB_HOST="${DATABASE_HOST}"
DB_USER="${DATABASE_USER}"
DB_PORT="${DATABASE_PORT}"

echo "Waiting for Postgres to be ready at $DB_HOST:$DB_PORT with user $DB_USER..."

until pg_isready -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER"; do
  echo "Waiting for the database to be ready..."
  sleep 1
done

echo "Database is ready"

echo "Run rails migration"
bundle exec rails db:migrate

# remove the pids if available
if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

# Start the server
exec "$@"
