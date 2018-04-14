FROM ubuntu:16.04

RUN DEBIAN_FRONTEND="noninteractive" \
&& apt-get update -y && apt-get install -y \
  software-properties-common \
  wget \
  locales \
  sudo \
&& apt-get clean

RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list' \
 && wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | apt-key add - \
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

COPY docker/dev/app/entrypoint.sh /etc/
COPY docker/dev/psql/* /etc/

#ENTRYPOINT ["/bin/bash", "-c", "/etc/runscripts.sh"]
#ENTRYPOINT /etc/runscripts.sh
#CMD ["/etc/startdb.sh"]

ENTRYPOINT ["/etc/entrypoint.sh"]
CMD ["/etc/startdb"]
