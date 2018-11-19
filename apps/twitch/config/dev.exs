use Mix.Config

config :twitch, Twitch.Repo,
  hostname: "localhost",
  username: "homepage",
  password: nil,
  port: 5432,
  pool_size: 10
