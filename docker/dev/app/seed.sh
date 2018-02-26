#!/bin/bash

set -ex

cd /root
ls -alh

mix ecto.create --force
mix ecto.migrate
