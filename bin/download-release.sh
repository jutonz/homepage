#!/bin/bash

keyfile="key.txt"

if ! command -v op > /dev/null; then
  echo "The 1Password cli, op, is not installed."
  echo "Please run \`brew install 1password-cli\`"
  exit 1
fi

if ! test -f "secrets.txt.encrypted"; then
  echo "Couldn't find encrypted secrets."
  echo "Make sure you run ./bin/encrypt_secrets.sh before trying to deploy."
  exit 1
fi

if ! test -f "$keyfile"; then
  key=$(
    op item get \
    "Secret key" \
    --account "my.1password.com" \
    --vault="Homepage" \
    --fields="password"
  )
  echo $key > "$keyfile"
fi

set -ex

token=$(
  op item get \
  "Homepage deploy GH token" \
  --account "my.1password.com" \
  --vault="Homepage" \
  --fields="credential" \
  --format=json \
  | jq -r .value
)

archive_url=$(curl -L \
  --silent \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $token" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/jutonz/homepage/actions/artifacts?name=release \
  | jq -r .artifacts[0].archive_download_url)

rm -rf tmp/deploy
mkdir -p tmp/deploy

curl \
  -L \
  -o tmp/deploy/release.zip \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $token" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  $archive_url

unzip -q tmp/deploy/release.zip -d tmp/deploy/
rm tmp/deploy/release.zip

mkdir -p tmp/deploy/secrets
cp bin/decrypt_secrets.sh key.txt secrets.txt.encrypted tmp/deploy/secrets

# These permissions get reset when being archived on GHA
chmod +x \
  tmp/deploy/bin/* \
  tmp/deploy/releases/**/elixir \
  tmp/deploy/erts-**/bin/* \
  tmp/deploy/lib/**/priv/bin/*

build_host=192.168.1.217

ssh $build_host -C "sudo systemctl stop homepage"
ssh $build_host -C "rm -rf srv/homepage"

rsync -a tmp/deploy/ $build_host:srv/homepage/

ssh $build_host -C "cd srv/homepage && ./bin/post_deploy.sh"
