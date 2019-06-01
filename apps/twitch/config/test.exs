use Mix.Config

config :twitch, Twitch.GoogleRepo,
  adapter: Ecto.Adapters.Postgres,
  pool: Ecto.Adapters.SQL.Sandbox,
  database: "homepage_twitch_google_test",
  hostname: "localhost",
  username: "postgres",
  password: nil

config :twitch, Twitch.Repo,
  adapter: Ecto.Adapters.Postgres,
  pool: Ecto.Adapters.SQL.Sandbox,
  database: "homepage_twitch_test",
  hostname: "localhost",
  username: "postgres",
  password: nil
