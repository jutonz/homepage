use Mix.Config

db_url = System.get_env("TWITCH_DATABASE_URL")
db_pool_size = System.get_env("POOL_SIZE") || "10" |> String.to_integer()

config :twitch, Twitch.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: db_url,
  pool_size: db_pool_size,
  ssl: true
