#!/bin/bash

set -ex

# Idential to seed.sh, but moves to /tmp/code rather than /root to find app files.

cd /tmp/code

cp -r /tmp/code/deps deps
cp -r /tmp/code/_build _build
ls -alh

mix ecto.create --force
mix ecto.migrate
