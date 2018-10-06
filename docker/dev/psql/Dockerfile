FROM postgres:10.0-alpine

COPY docker/dev/app/entrypoint.sh /docker-entrypoint-initdb.d/
COPY docker/dev/psql/* /etc/
