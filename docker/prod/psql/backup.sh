#/bin/bash

PGPASSWORD=$POSTGRES_PASSWORD \
  pg_dump \
  --host=psql \
  --dbname=$POSTGRES_DB \
  --username=$POSTGRES_USER \
  -Fc \
  > /tmp/$POSTGRES_DB.dump

aws s3 cp \
  /tmp/$POSTGRES_DB.dump \
  s3://jutonz-homepage-prod-db-backups/$POSTGRES_DB.dump

rm /tmp/$POSTGRES_DB.dump
