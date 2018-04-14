FROM elixir:1.6

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
  libpq-dev \ # postgres adapter lib
  inotify-tools \ # for phoenix code reloader
&& rm -rf /var/lib/apt/lists/*

# Build tools + phoenix exe
RUN mix local.rebar --force \
    && mix local.hex --force \
    && mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez --force

COPY docker/dev/app/*.sh /etc/
COPY docker/dev/app/runscripts /usr/bin/

ENTRYPOINT ["runscripts", "/etc/setup.sh"]
CMD ["/etc/start.sh"]
