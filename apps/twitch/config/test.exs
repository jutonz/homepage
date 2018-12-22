use Mix.Config

config :twitch, Twitch.Repo,
  adapter: Ecto.Adapters.Postgres,
  pool: Ecto.Adapters.SQL.Sandbox,
  database: "homepage_twitch_test",
  hostname: "localhost",
  username: "homepage",
  password: nil,
  port: 5432,
  pool_size: 10
