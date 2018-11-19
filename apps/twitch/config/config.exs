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

db_host = System.get_env("DB_HOST")
db_port = System.get_env("DB_PORT")
db_user = System.get_env("DB_USER")
db_pass = System.get_env("DB_PASS")
db_name = "homepage_twitch_" <> to_string(Mix.env())
db_pool_size = System.get_env("DB_POOL_SIZE") || "10" |> String.to_integer()

config :twitch, Twitch.Repo,
  adapter: Ecto.Adapters.Postgres,
  hostname: db_host,
  username: db_user,
  password: db_pass,
  port: db_port,
  database: db_name,
  pool_size: db_pool_size

import_config "#{Mix.env()}.exs"
