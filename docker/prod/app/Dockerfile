FROM elixir:1.6

RUN DEBIAN_FRONTEND="noninteractive" \
&& apt-get update -y && apt-get install -y \
  software-properties-common \
  wget \
  locales \
&& rm -rf /var/lib/apt/lists/*

USER root
ENV HOME /root
WORKDIR /root

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
&& rm -rf /var/lib/apt/lists/*

# Node
RUN export DEBIAN_FRONTEND="noninteractive" \
 && curl -sL https://deb.nodesource.com/setup_6.x | bash - \
 && apt-get install -y nodejs

# Yarn
RUN export DEBIAN_FRONTEND="noninteractive" \
 && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - \
 && echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list \
 && apt-get update \
 && apt-get install -y yarn

COPY docker/prod/app/init.sh /etc/

COPY . /root/code/
WORKDIR /root/code

# Build frontend and backend in parallel
RUN (MIX_ENV=prod mix local.hex --force && MIX_ENV=prod mix local.rebar --force && MIX_ENV=prod mix deps.get && MIX_ENV=prod mix compile) & (cd apps/client/assets && yarn && yarn cache clean && yarn run bundle); wait

# Fingerprint frontend assets
RUN MIX_ENV=prod mix phx.digest

CMD ["/bin/bash", "-c", "/etc/init.sh"]
