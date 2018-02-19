#!/bin/bash

set -x
set -e

cd /root

ls -alh deps

mix ecto.setup --force
#mix ecto.create --force
mix ecto.migrate
