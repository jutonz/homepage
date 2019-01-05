use Mix.Config

config :twitch, Twitch.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "homepage_twitch_dev",
  hostname: "localhost"
