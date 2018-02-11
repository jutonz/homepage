#/bin/bash

set -e

# Runing as postgres user

cd

res=`aws s3api head-object \
  --bucket jutonz-homepage-prod-db-backups \
  --key ci_prod.dump` || true

if [ -n "$res" ]; then
  aws s3 cp s3://jutonz-homepage-prod-db-backups/ci_prod.dump ci_prod.dump

  # pg_restore returns nonzero code since some imports don't work. This is okay,
  # so return true to keep container running (nonzero will kill it)
  pg_restore -d $POSTGRES_DB --role=$POSTGRES_USER ci_prod.dump || true
fi

