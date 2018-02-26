#!/bin/bash

set -ex

# Idential to seed.sh, but moves to /tmp/code rather than /root to find app files.

cd /tmp/app

cp -r /tmp/code/deps deps
cp -r /tmp/code/_build _build

MIX_ENV=test PG_HOST=psql mix ecto.create --force
MIX_ENV=test PG_HOST=psql mix ecto.migrate
