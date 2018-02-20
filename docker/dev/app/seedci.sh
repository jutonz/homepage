#!/bin/bash

# Idential to seed.sh, but moves to /tmp/code rather than /root to find app files.

set -x
set -e

cd /tmp/code
ls -alh

mix ecto.create --force
mix ecto.migrate
