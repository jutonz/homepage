VERSION 0.6
FROM hexpm/elixir:1.13.3-erlang-24.0.3-ubuntu-focal-20210325
WORKDIR /elxir-workdir

build:
  COPY . .
  RUN rm -rf _build
  RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*
  RUN MIX_ENV=prod mix do local.hex --force, local.rebar --force, deps.get
  RUN MIX_ENV=prod mix release homepage
  SAVE ARTIFACT --force _build/prod/rel/homepage AS LOCAL tmp/deploy
