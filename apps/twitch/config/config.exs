# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :twitch, ecto_repos: [Twitch.Repo]

config :twitch,
  oauth: %{
    client_id: System.get_env("TWITCH_CLIENT_ID"),
    client_secret: System.get_env("TWITCH_CLIENT_SECRET"),
    redirect_uri: System.get_env("TWITCH_REDIRECT_URI")
  }

db_url = System.get_env("DATABASE_URL")
db_pool_size = System.get_env("POOL_SIZE") || "10" |> String.to_integer()

config :twitch, Twitch.Repo,
adapter: Ecto.Adapters.Postgres,
  url: db_url,
  pool_size: db_pool_size,
  ssl: true

import_config "#{Mix.env()}.exs"
