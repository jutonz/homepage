use Mix.Config

config :twitch, Twitch.Repo,
  adapter: Ecto.Adapters.Postgres,
  pool: Ecto.Adapters.SQL.Sandbox,
  database: "homepage_twitch_test",
  hostname: "localhost",
  username: "postgres",
  password: nil

config :twitch, bttv_api_client: Twitch.BttvApiMock
