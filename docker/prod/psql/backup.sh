#/bin/bash

pg_dump --dbname=homepage_prod --username=homepage -Fc > /tmp/homepage_prod.dump

aws s3 cp /tmp/homepage_prod.dump s3://jutonz-homepage-prod-db-backups/homepage_prod.dump

rm /tmp/homepage_prod.dump
