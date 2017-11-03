FROM postgres:10.0-alpine

# Install aws-cli for database backups
RUN apk --no-cache update \
  && apk --no-cache add python py-pip py-setuptools ca-certificates curl groff less \
  && pip --no-cache-dir install awscli \
  && rm -rf /var/cache/apk/*

COPY docker/prod/psql/backup.sh /etc/

# The psql image automatically sources files in this directory. Use this to
# pull down a database backup from s3 to recover from emergency shutdown.
COPY docker/prod/psql/initdb.sh /docker-entrypoint-initdb.d/
