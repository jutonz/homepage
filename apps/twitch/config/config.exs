# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :twitch, ecto_repos: [Twitch.Repo]

config :twitch,
  oauth: %{
    client_id: System.get_env("TWITCH_CLIENT_ID"),
    client_secret: System.get_env("TWITCH_CLIENT_SECRET"),
    redirect_uri: System.get_env("TWITCH_REDIRECT_URI")
  }

config :exenv,
  adapters: [
    {Exenv.Adapters.Dotenv,
     [
       file: "config/.env.enc",
       encryption: [master_key: "config/master.key"]
     ]}
  ]

config :goth, config_module: Twitch.GothConfig

import_config "#{Mix.env()}.exs"
