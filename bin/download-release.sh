#!/bin/bash

set -ex

token=$GITHUB_DEPLOY_TOKEN

archive_url=$(curl -L \
  --silent \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $token" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/jutonz/homepage/actions/artifacts?name=release \
  | jq -r .artifacts[0].archive_download_url)

rm -rf tmp/deploy
mkdir -p tmp/deploy

wget \
  -O tmp/deploy/release.zip \
  --header "Accept: application/vnd.github+json" \
  --header="Authorization: Bearer $token" \
  --header "X-GitHub-Api-Version: 2022-11-28" \
  $archive_url

unzip tmp/deploy/release.zip -d tmp/deploy/
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
