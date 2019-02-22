#!/bin/bash

set -ex

cd apps/client
mix do ecto.migrate, run priv/repo/seeds.exs
cd -

cd apps/twitch
mix ecto.migrate
cd -
