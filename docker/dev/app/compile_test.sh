#!/bin/bash

set -ex

cd /tmp/app
MIX_ENV=test mix deps.compile
