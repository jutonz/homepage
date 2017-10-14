#!/bin/bash

cd /root

# Remove node modules installed on host, if any
rm -r assets/node_modules

# Copy node modules which were installed during container build phase.
# Note that it's important to copy (not move or symlink) these resources as it
# appears that some packages use relative paths or hardcode paths at build
# time.  Alternatively move mix deps.compile outside of container build phase.
cp -r /tmp/code/assets/node_modules assets/node_modules

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

mix local.hex --force
mix local.rebar --force

iex -S mix phx.server
