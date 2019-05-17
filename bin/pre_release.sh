#!/bin/bash

set -ex

cd apps/twitch
echo $TWITCH_DB_CLIENT_CERT | base64 --decode > priv/client-cert.pem
echo $TWITCH_DB_CLIENT_KEY | base64 --decode > priv/client-key.pem
echo $TWITCH_DB_SERVER_CA | base64 --decode > priv/server-ca.pem
mkdir -p priv/repo/migrations
mix ecto.migrate
cd -

cd apps/client
mix do ecto.migrate, run priv/repo/seeds.exs
cd -
