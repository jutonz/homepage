FROM jutonz/homepage-dev-app:12

COPY . /root/code/

WORKDIR /root/code

COPY docker/prod/app/init.sh /etc/

RUN mv /tmp/code/apps/client/assets/node_modules apps/client/assets/node_modules
RUN mv /tmp/code/deps deps
RUN cd apps/client/assets && yarn && yarn run bundle
RUN MIX_ENV=prod mix local.rebar --force
RUN MIX_ENV=prod mix compile
RUN MIX_ENV=prod mix phx.digest

CMD ["/bin/bash", "-c", "/etc/init.sh"]
