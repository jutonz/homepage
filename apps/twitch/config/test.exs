use Mix.Config

config :twitch, Twitch.Repo,
  pool: Ecto.Adapters.SQL.Sandbox,
  hostname: "localhost",
  username: "homepage",
  password: nil,
  port: 5432
