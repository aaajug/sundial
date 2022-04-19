#!/bin/bash
# Docker entrypoint script.

# Wait until Postgres is ready.
# while ! pg_isready -q -h db -p 5432 -U postgres
# do
#   echo "$(date) - waiting for database to start"
#   sleep 2
# done

echo "Starting to create database... (backend/entrypoint)"

print_db_name()
{
  `PGPASSWORD=postgres psql -h db
  -U postgres -Atqc "\\list sundial_dev"`
}

# Create, migrate, and seed database if it doesn't exist.
if ! [[ -z print_db_name ]]; then
  echo "Database sundial_dev does not exist. Creating..."
  # createdb -E UTF8 sundial_dev en_US.UTF-8 -T template0
  mix ecto.drop
  mix ecto.create
  # mix run priv/repo/seeds.exs
  echo "Database sundial_dev created."

  mix ecto.migrate
  echo "Database sundial_dev migrated."
fi

exec mix phx.server