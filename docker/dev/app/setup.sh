#!/bin/bash

################################################################################
# This is run each time the app container is started. Mostly it ensures that
# required dependencies are present.
################################################################################

set -x

if [ -n "$CI" ]; then	+cd /app
  cd /tmp/ciapp
else
  cd /app
fi

ls -alh

mix deps.get
