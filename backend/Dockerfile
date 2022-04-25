#!/bin/bash

FROM bitwalker/alpine-elixir-phoenix:latest

# RUN apt-get update && \
#   apt-get install -y postgresql-client

WORKDIR /app

COPY mix.exs .
COPY mix.lock .

RUN mkdir assets

# COPY assets/package.json assets
COPY assets/package-lock.json assets

# CMD mix deps.get && cd assets && npm install && cd .. && mix phx.server
CMD mix deps.get
CMD mix deps.compile

# CMD pwd
# CMD ["../app/entrypoint.sh"]
CMD mix phx.server