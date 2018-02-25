#!/bin/bash

set -ex

cd $CODE_DIR
MIX_ENV=test mix deps.compile
