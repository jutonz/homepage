FROM jutonz/homepage-dev-app:3

COPY . /root/code/

WORKDIR /root/code

COPY docker/prod/app/init.sh /etc/

RUN ln -s /tmp/code/assets/node_modules assets/node_modules
RUN cd assets && yarn && NODE_ENV=production brunch build
RUN MIX_ENV=prod mix local.rebar --force
RUN MIX_ENV=prod mix compile
RUN MIX_ENV=prod mix phx.digest

CMD ["/bin/bash", "-c", "/etc/init.sh"]
