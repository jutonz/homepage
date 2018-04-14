#!/bin/bash

set -ex

if [ -n "$CI" ]; then	+cd /app
  cd /tmp/ciapp
else
  cd /app
fi


mix ecto.create --force
mix ecto.migrate
