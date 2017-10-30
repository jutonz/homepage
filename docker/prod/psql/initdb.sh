#/bin/bash

set -e

# Runing as postgres user

cd

aws s3 cp s3://jutonz-homepage-prod-db-backups/homepage_prod.dump homepage_prod.dump

# pg_restore returns nonzero code since some imports don't work. This is okay,
# so return true to keep container running (nonzero will kill it)
pg_restore -d homepage_prod --role=homepage homepage_prod.dump || true
