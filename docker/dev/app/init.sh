#!/bin/bash

cd /root

# Remove node modules installed on host, if any
rm -r assets/node_modules

# Link node modules which were installed during container build phase
mv /tmp/code/assets/node_modules assets/node_modules

# Remove hex deps installed on host, if any
rm -r deps

# Link hex deps which were installed during container build phase
mv /tmp/code/deps deps

# Remove build artifacts on host, if any
rm -r _build

# Link hex deps which were compiled during container build phase
mv /tmp/code/_build _build

mix local.hex --force
mix local.rebar --force

iex -S mix phx.server
