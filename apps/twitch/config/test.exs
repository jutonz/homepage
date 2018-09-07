use Mix.Config

config :twitch, Twitch.Repo,
  pool: Ecto.Adapters.SQL.Sandbox
