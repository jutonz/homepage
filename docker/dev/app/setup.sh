#!/bin/bash

################################################################################
# This is run each time the app container is started. Mostly it ensures that
# required dependencies are present.
################################################################################

set -x

cd /app

mix deps.get
