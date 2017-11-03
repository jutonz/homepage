#/bin/bash

PGPASSWORD=$POSTGRES_PASSWORD \
  pg_dump \
  --host=psql \
  --dbname=$POSTGRES_DB \
  --username=$POSTGRES_USER \
  -Fc \
  > /tmp/homepage_prod.dump

aws s3 cp \
  /tmp/homepage_prod.dump \
  s3://jutonz-homepage-prod-db-backups/homepage_prod.dump

rm /tmp/homepage_prod.dump
