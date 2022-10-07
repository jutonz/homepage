VERSION 0.6
FROM elixir:1.13-otp-25-slim
WORKDIR /elxir-workdir

build:
  COPY . .
  RUN MIX_ENV=prod mix do local.hex --force, local.rebar --force, deps.get, release homepage
  SAVE ARTIFACT _build/prod/rel/homepage AS LOCAL tmp/testin
