FROM elixir:1.7

WORKDIR /app

# Utility packages
RUN export DEBIAN_FRONTEND="noninteractive" \
&& apt-get update -y && apt-get install -y \
  build-essential \
  vim \
  git \
  curl \
  tzdata \
  htop \
  sudo \
  libpq-dev \
  inotify-tools \
&& rm -rf /var/lib/apt/lists/*

# Build tools + phoenix exe
RUN mix local.rebar --force \
    && mix local.hex --force \
    && mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez --force

COPY docker/dev/app/* /etc/
COPY docker/dev/app/remsh /usr/bin/
COPY docker/dev/app/setup /etc/entrypoint.d/

ENTRYPOINT ["/etc/entrypoint.sh"]
CMD ["/etc/start"]
