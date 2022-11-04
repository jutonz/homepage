VERSION 0.6
FROM hexpm/elixir:1.13.3-erlang-24.0.3-ubuntu-focal-20210325
WORKDIR /elxir-workdir

assets:
  FROM node:16.16-alpine3.15
  COPY . .
  WORKDIR apps/client/assets
  RUN yarn install
  ENV NODE_ENV=production
  ENV MIX_ENV=prod
  RUN yarn run bundle:js
  RUN yarn run bundle:css
  SAVE ARTIFACT ../priv/static /priv/static

build:
  ENV MIX_ENV=prod
  RUN rm -rf _build
  RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*
  COPY . .
  RUN MIX_ENV=prod mix do local.hex --force, local.rebar --force, deps.get
  RUN mix compile
  COPY +assets/priv/static apps/client/priv/static
  RUN ls -alh apps/client/priv/static
  RUN mix phx.digest
  RUN mix release homepage
  SAVE ARTIFACT --force _build/prod/rel/homepage AS LOCAL tmp/deploy
