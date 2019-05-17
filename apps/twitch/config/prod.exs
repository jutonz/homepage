use Mix.Config

db_url = System.get_env("TWITCH_DATABASE_URL")
db_google_url = System.get_env("TWITCH_GOOGLE_DATABASE_URL")
db_pool_size = System.get_env("POOL_SIZE") || "10" |> String.to_integer()

ssl_opts =
  if System.get_env("TWITCH_DB_SERVER_CA") do
    [
      cacertfile: "/app/apps/twitch/priv/server-ca.pem",
      keyfile: "/app/apps/twitch/priv/client-key.pem",
      certfile: "/app/apps/twitch/priv/client-cert.pem"
    ]
  else
    []
  end

config :twitch, Twitch.GoogleRepo,
  adapter: Ecto.Adapters.Postgres,
  url: db_google_url,
  pool_size: db_pool_size,
  ssl: true,
  ssl_opts: ssl_opts

config :twitch, Twitch.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: db_url,
  pool_size: db_pool_size
