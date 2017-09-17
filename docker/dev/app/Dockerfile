FROM jutonz/homepage-dev-base:1

# Install ruby and sass gem
RUN apt-get update \
 && apt-get install -y ruby ruby-dev \
 && gem install sass --no-document

# Install hex deps
COPY mix.exs /tmp/code/
RUN cd /tmp/code && mix local.hex --force && mix local.rebar --force && mix deps.get

# Install node deps
RUN yarn global add brunch
COPY assets/package.json assets/yarn.lock /tmp/code/assets/
RUN cd /tmp/code/assets && yarn

# Install phoenix
RUN mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez --force

COPY docker/dev/app/init.sh /etc/

CMD ["/bin/bash", "-c", "/etc/init.sh"]
