#!/bin/bash

if ! test -f "key.txt"; then
  echo "Couldn't find \"key.txt\". Make sure you create it before trying to deploy."
  exit 1
fi

if ! test -f "secrets.txt.encrypted"; then
  echo "Couldn't find encrypted secrets."
  echo "Make sure you run ./bin/encrypt_secrets.sh before trying to deploy."
  exit 1
fi

set -ex

export EARTHLY_BUILDKIT_HOST=tcp://littlebox.local:8372

rm -rf tmp/deploy
earthly +build

# TODO: Stop existing server, if one is running

ssh littlebox -C "rm -rf srv/homepage"

mkdir -p tmp/deploy/secrets
cp bin/decrypt_secrets.sh key.txt secrets.txt.encrypted tmp/deploy/secrets

rsync -a tmp/deploy/ littlebox:srv/homepage/

ssh littlebox -C "cd srv/homepage && ./bin/homepage eval \"Client.Release.migrate()\""
ssh littlebox -C "cd srv/homepage && ./bin/homepage eval \"Twitch.Release.migrate()\""

# TODO: start server
