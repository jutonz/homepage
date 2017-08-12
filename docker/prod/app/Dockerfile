FROM jutonz/homepage-dev-app:1

COPY . /root/code/

WORKDIR /root/code

COPY docker/prod/app/init.sh /etc/
RUN cd assets && brunch build --production
RUN MIX_ENV=prod mix local.rebar --force
RUN MIX_ENV=prod mix compile
RUN MIX_ENV=prod mix phx.digest

CMD ["/bin/bash", "-c", "/etc/init.sh"]
