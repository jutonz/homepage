#!/bin/bash

set -x
set -e

cd /root

ls -alh deps

mix ecto.create --force
mix ecto.migrate
