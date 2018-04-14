#!/bin/bash

set -ex

# Idential to seed.sh, but moves to /tmp/code rather than /root to find app files.

if [ -n "$CI" ]; then	+cd /app
  cd /tmp/ciapp
else
  cd /app
fi

MIX_ENV=test PG_HOST=psql mix ecto.drop
MIX_ENV=test PG_HOST=psql mix ecto.create --force
MIX_ENV=test PG_HOST=psql mix ecto.migrate
