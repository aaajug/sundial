#!/bin/bash

FROM bitwalker/alpine-elixir-phoenix:latest

WORKDIR /app

COPY mix.exs .
COPY mix.lock .

RUN mkdir assets

COPY assets/package-lock.json assets
COPY assets/css assets
COPY assets/js assets
COPY priv/static/assets priv/static/

RUN mix local.hex --force
CMD mix deps.get

# RUN mix do compile
# COPY deps/tesla/lib/tesla/adapter/httpc.ex deps/tesla/lib/tesla/adapter/
CMD mix deps.compile

# CMD mix deps.get

# COPY _build/sass-linux-x64 _build

CMD mix phx.server