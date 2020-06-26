import Config

config :twitch,
  ecto_repos: [Twitch.Repo],
  oauth: %{
    client_id: System.get_env("TWITCH_CLIENT_ID"),
    client_secret: System.get_env("TWITCH_CLIENT_SECRET"),
    redirect_uri: System.get_env("TWITCH_REDIRECT_URI")
  },
  bttv_api_client: Twitch.Bttv.Api,
  twitch_emotes_api_client: Twitch.TwitchEmotes.Api,
  api_cache_name: :api_cache,
  webhook_secret: System.get_env("TWITCH_CLIENT_ID")

config :exenv,
  adapters: [
    {Exenv.Adapters.Dotenv,
     [
       file: "apps/twitch/config/.env.enc",
       encryption: [master_key: "apps/twitch/config/master.key"]
     ]}
  ]

case System.get_env("TWITCH_DATASTORE_DISABLED") do
  "true" ->
    config :goth, disabled: true

  _ ->
    config :goth, config_module: Twitch.GothConfig
end

import_config "#{Mix.env()}.exs"
