ARG ELIXIR_VERSION=1.18.2
ARG OTP_VERSION=27.2
ARG DEBIAN_VERSION=bullseye-20241223
ARG NODE_VERSION=22.12.0

ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-debian-${DEBIAN_VERSION}"
ARG RUNNER_IMAGE="debian:${DEBIAN_VERSION}"

################################################################################
# node_builder
################################################################################

FROM node:${NODE_VERSION} AS node_builder

ENV MIX_ENV=prod

RUN mkdir -p /assets/apps/client/assets
WORKDIR /assets/apps/client/assets

COPY apps/client/assets/yarn.lock apps/client/assets/package.json .
RUN yarn

COPY apps/client/assets .

RUN yarn bundle:css
RUN yarn bundle:js

################################################################################
# builder
################################################################################

FROM ${BUILDER_IMAGE} AS builder

RUN apt-get update -y && apt-get install -y build-essential git \
    && apt-get clean && rm -f /var/lib/apt/lists/*_*

WORKDIR /app

RUN mix local.hex --force && \
    mix local.rebar --force

ENV MIX_ENV="prod"

# needed to support cross complilation
# https://elixirforum.com/t/cross-compiling-a-release-with-apple-m1-and-docker/55615/3
ENV ERL_AFLAGS="+JMsingle true"

COPY apps/client/mix.exs apps/client/mix.exs
COPY apps/events/mix.exs apps/events/mix.exs
COPY apps/redis/mix.exs apps/redis/mix.exs
COPY apps/twitch/mix.exs apps/twitch/mix.exs
COPY mix.exs mix.exs
COPY mix.lock mix.lock
RUN mix deps.get --only $MIX_ENV
RUN mkdir config

# copy compile-time config files before we compile dependencies
# to ensure any relevant config change will trigger the dependencies
# to be re-compiled.
COPY config/config.exs config/${MIX_ENV}.exs config/
RUN mix deps.compile

COPY apps apps
COPY bin bin

RUN mix compile

# Changes to config/runtime.exs don't require recompiling the code
COPY config/runtime.exs config/

# copy over compiled assets and digest them
COPY \
  --from=node_builder \
  --chown=root:root \
  /assets/apps/client/priv/static \
  /app/apps/client/priv/static
RUN mix phx.digest

COPY rel rel
RUN mix release

################################################################################
# runner
################################################################################

FROM ${RUNNER_IMAGE}

RUN apt-get update -y && \
  apt-get install -y libstdc++6 openssl libncurses5 locales ca-certificates ccrypt \
  && apt-get clean && rm -f /var/lib/apt/lists/*_*

# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

WORKDIR "/app"
RUN chown nobody /app

ENV MIX_ENV="prod"

COPY --from=builder --chown=nobody:root /app/_build/${MIX_ENV}/rel/homepage ./

RUN mkdir secrets/
COPY \
  bin/decrypt_secrets.sh \
  secrets.txt.encrypted \
  secrets/
RUN chown -R nobody:root secrets/

COPY bin/docker-entrypoint.sh bin/docker-entrypoint.sh
ENTRYPOINT ["/app/bin/docker-entrypoint.sh"]

USER nobody

# If using an environment that doesn't automatically reap zombie processes, it is
# advised to add an init process such as tini via `apt-get install`
# above and adding an entrypoint. See https://github.com/krallin/tini for details
# ENTRYPOINT ["/tini", "--"]

EXPOSE 4000
CMD ["/app/bin/homepage", "start"]
