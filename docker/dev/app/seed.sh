#!/bin/bash

set -ex

cd /root

mix ecto.create --force
mix ecto.migrate
