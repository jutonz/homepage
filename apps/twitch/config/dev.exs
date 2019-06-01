use Mix.Config

config :twitch, Twitch.GoogleRepo,
  adapter: Ecto.Adapters.Postgres,
  database: "homepage_twitch_google_dev",
  hostname: "localhost"

config :twitch, Twitch.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "homepage_twitch_dev",
  hostname: "localhost"
