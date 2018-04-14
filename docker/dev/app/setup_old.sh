#!/bin/bash

################################################################################
# This is run each time the app container is started. Mostly it ensures that
# required dependencies are present.
################################################################################

set -x

if [ -n "$CI" ]; then
  cd /tmp/app
else
  cd /root
fi

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
