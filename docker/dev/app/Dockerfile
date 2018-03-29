FROM ubuntu:16.04

RUN DEBIAN_FRONTEND="noninteractive" \
&& apt-get update -y && apt-get install -y \
  software-properties-common \
  wget \
  locales \
&& rm -rf /var/lib/apt/lists/*

USER root
ENV HOME /root
WORKDIR /root

# Configure locale
RUN locale-gen en_US.utf8 && update-locale LANG=en_US.utf8 LC_ALL=en_US.utf8

# Utilility packages
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

# Erlang and Elixir
RUN export DEBIAN_FRONTEND="noninteractive" \
  && wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb \
  && dpkg -i erlang-solutions_1.0_all.deb \
  && apt-get update \
  && apt-get install -y esl-erlang elixir \
  && rm erlang-solutions_1.0_all.deb

# Node
RUN export DEBIAN_FRONTEND="noninteractive" \
 && curl -sL https://deb.nodesource.com/setup_6.x | bash - \
 && apt-get install -y nodejs

# Install hex deps
COPY mix.exs mix.lock /tmp/code/
COPY apps/client/mix.exs /tmp/code/apps/client/
COPY apps/auth/mix.exs /tmp/code/apps/auth/
COPY apps/redis/mix.exs /tmp/code/apps/redis/
RUN cd /tmp/code \
  && mix local.hex --force \
  && mix local.rebar --force \
  && mix deps.get

RUN cd /tmp/code && mix deps.compile
RUN cd /tmp/code && MIX_ENV=test mix deps.compile

# Install phoenix
RUN mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez --force

COPY docker/dev/app/*.sh /etc/
COPY docker/dev/app/runscripts /usr/bin/

ENTRYPOINT ["runscripts", "/etc/setup.sh"]
CMD ["/etc/start.sh"]
