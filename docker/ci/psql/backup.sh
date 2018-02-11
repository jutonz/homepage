#/bin/bash

PGPASSWORD=$POSTGRES_PASSWORD \
  pg_dump \
  --host=psql \
  --dbname=$POSTGRES_DB \
  --username=$POSTGRES_USER \
  -Fc \
  > /tmp/ci_prod.dump

aws s3 cp \
  /tmp/ci_prod.dump \
  s3://jutonz-homepage-prod-db-backups/ci_prod.dump

rm /tmp/ci_prod.dump
