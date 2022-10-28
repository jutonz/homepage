#!/bin/bash

set -ex

export EARTHLY_BUILDKIT_HOST=tcp://littlebox.local:8372

rm -rf tmp/deploy
earthly +build

ssh littlebox -C "rm -rf srv/homepage"

mkdir -p tmp/deploy/secrets
cp bin/decrypt_secrets.sh key.txt secrets.txt.encrypted tmp/deploy/secrets

rsync -a tmp/deploy/ littlebox:srv/homepage/

# stop running server if there is one
# copy binary back to littlebox
# start new server
