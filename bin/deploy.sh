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

if ! command -v earthly > /dev/null; then
  echo "The command \"earthly\" was not installed."
  echo "Please install it to continue."
  echo "Probably you want \`brew install earthly\`"
  exit 1
fi

set -ex

# Note: You may have to replace this hostname with the IP if it fails to
# connect. Not sure why 🤔
#export EARTHLY_BUILDKIT_HOST=tcp://littlebox.local:8372
export EARTHLY_BUILDKIT_HOST=tcp://192.168.1.217:8372

rm -rf tmp/deploy
earthly +build

ssh littlebox -C "sudo systemctl stop homepage"
ssh littlebox -C "rm -rf srv/homepage"

mkdir -p tmp/deploy/secrets
cp bin/decrypt_secrets.sh key.txt secrets.txt.encrypted tmp/deploy/secrets

rsync -a tmp/deploy/ littlebox:srv/homepage/

ssh littlebox -C "cd srv/homepage && ./bin/post_deploy.sh"
