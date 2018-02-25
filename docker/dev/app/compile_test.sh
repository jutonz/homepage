#!/bin/bash

set -ex

cd /tmp/code
MIX_ENV=test mix deps.compile
