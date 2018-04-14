#!/bin/bash

set -ex

# Idential to seed.sh, but moves to /tmp/code rather than /root to find app files.

cd /app

MIX_ENV=test PG_HOST=psql mix ecto.drop
MIX_ENV=test PG_HOST=psql mix ecto.create --force
MIX_ENV=test PG_HOST=psql mix ecto.migrate
