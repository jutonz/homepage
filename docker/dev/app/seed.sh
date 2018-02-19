#!/bin/bash

set -x

cd /root

ls -alh

mix deps.get

PG_HOST=127.0.0.1 mix ecto.create --force
PG_HOST=127.0.0.1 mix ecto.migrate
