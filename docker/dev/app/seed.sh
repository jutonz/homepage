#!/bin/bash

set -x
set -e

cd /root/apps/client

mix ecto.create --force
mix ecto.migrate
