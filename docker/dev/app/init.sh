#!/bin/bash

cd /root

# Remove node modules installed on host, if any
rm -r assets/node_modules

# Link node modules which were installed during container build phase
ln -s /tmp/code/assets/node_modules assets/node_modules

# Remove hex deps installed on host, if any
rm -r deps

# Link hex deps which were installed during container build phase
# Turning this off for now in favor of just installing when starting container
#ln -s /tmp/code/deps deps

mix local.hex --force
mix local.rebar --force
mix deps.get --force

#ln -s /tmp/code/.mix .mix

iex -S mix phx.server
