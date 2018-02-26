#!/bin/bash

set -x

cd /tmp/app

# Remove hex deps installed on host, if any
rm -r deps

# Copy hex deps which were installed during container build phase. See above
# note about copying.
cp -r /tmp/code/deps deps

# Remove build artifacts on host, if any
rm -r _build

# Copy hex deps which were compiled during container build phase. See above
# note about copying.
cp -r /tmp/code/_build _build

# We don't have to remove node_modules manually since we define a docker volume
# to /root/assets/node_modules, but didn't specify a mount point at the host
# machine. This allows us to modify this directory without spending tons of
# CPU to try and sync the 8 million js files in that folder.

# Copy node modules which were installed during container build phase.
# Note that it's important to copy (not move or symlink) these resources as it
# appears that some packages use relative paths or hardcode paths at build
# time.  Alternatively move mix deps.compile outside of container build phase.
cp -R /tmp/code/apps/client/assets/node_modules/. apps/client/assets/node_modules/

mix local.hex --force
mix local.rebar --force
