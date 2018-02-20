#!/bin/bash

set -ex

# Idential to seed.sh, but moves to /tmp/code rather than /root to find app files.

cd /tmp/code

ls -alh /tmp/code
exit 1

#cp -r /tmp/code/deps deps
#cp -r /tmp/code/_build _build
#mix deps.get
#ls -alh

mix ecto.create --force
mix ecto.migrate
