#!/bin/bash

set -ex

cd apps/client
mix ecto.migrate
mix run priv/repo/seeds.exs
