FROM jutonz/homepage-dev-base:1

# Install hex
RUN mix local.hex --force

# Install ruby and sass gem
RUN apt-get update \
 && apt-get install -y ruby ruby-dev \
 && gem install sass --no-document

# Install hex deps
COPY mix.exs /tmp/code/
RUN cd /tmp/code && mix deps.get

# Install node deps
COPY package.json yarn.lock /tmp/code/
RUN npm i -g brunch && cd /tmp/code && yarn

# Install phoenix
RUN mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez --force
