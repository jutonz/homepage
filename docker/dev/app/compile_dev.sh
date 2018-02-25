#!/bin/bash

set -ex

cd $CODE_DIR
mix deps.compile
