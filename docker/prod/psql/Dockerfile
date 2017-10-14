FROM jutonz/homepage-prod-app:10

RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list' \
 && wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add - \
 && apt-get update && apt-get install postgresql postgresql-contrib --yes \
&& rm -rf /var/lib/apt/lists/*

# Adjust PostgreSQL configuration so that remote connections to the
# database are possible.
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/10/main/pg_hba.conf

# And add ``listen_addresses`` to ``/etc/postgresql/10/main/postgresql.conf``
RUN echo "listen_addresses='*'" >> /etc/postgresql/10/main/postgresql.conf
RUN echo "data_directory = '/var/lib/postgresql/data'" >> /etc/postgresql/10/main/postgresql.conf

RUN mkdir -p /var/lib/postgresql/data && chown -R postgres /var/lib/postgresql
RUN mkdir -p /var/run/postgresql/10-main.pg_stat_tmp && chown -R postgres /var/run/postgresql/10-main.pg_stat_tmp
RUN usermod -aG sudo postgres

WORKDIR /tmp

COPY docker/prod/psql/initdb.sh docker/prod/psql/startdb.sh /etc/
RUN chmod +x /etc/initdb.sh && chown postgres:postgres /etc/initdb.sh
RUN chmod +x /etc/startdb.sh && chown postgres:postgres /etc/startdb.sh

CMD ["/bin/bash", "-c", "/etc/startdb.sh"]
