#!/bin/bash
# Docker entrypoint script.

# Wait until Postgres is ready.
while ! pg_isready -q -h db -p 5432 -U postgres
do
  echo "$(date) - waiting for database to start"
  sleep 2
done
echo "Starting to create database..."

# Create, migrate, and seed database if it doesn't exist.
if [[ -z `psql -Atqc "\\list sundial_dev"` ]]; then
  echo "Database sundial_dev does not exist. Creating..."
  createdb -E UTF8 sundial_dev en_US.UTF-8 -T template0
  mix ecto.migrate
  # mix run priv/repo/seeds.exs
  echo "Database sundial_dev created."
fi

exec mix phx.server