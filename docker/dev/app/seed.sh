#!/bin/bash

set -x
set -e

cd /root
ls -alh

mix ecto.create --force
mix ecto.migrate
