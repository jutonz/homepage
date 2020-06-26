import Config

################################################################################
# Global config
################################################################################

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    "9Z4EOxi6xe+P7ci7gSQn/Lqt4QIXinGJu+CW4YI0lQYaBzFfJsvLvMDm2B38ETM+"

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

################################################################################
# Auth config
################################################################################

config :auth, Auth.Guardian,
  issuer: "homepage",
  secret_key: secret_key_base

################################################################################
# Client config
################################################################################

config :client,
  namespace: Client,
  ecto_repos: [Client.Repo],
  default_timezone: "EST"

config :phoenix,
  template_engines: [leex: Phoenix.LiveView.Engine]

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    "9Z4EOxi6xe+P7ci7gSQn/Lqt4QIXinGJu+CW4YI0lQYaBzFfJsvLvMDm2B38ETM+"

config :client, ClientWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: secret_key_base,
  render_errors: [view: ClientWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Client.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [
    signing_salt: "GakYThHq3i8b2wE+W12iNNKrwEzMkq6d"
  ],
  pubsub: [
    adapter: Phoenix.PubSub.PG2,
    pool_size: 1,
    name: Client.PubSub
  ]

config :logger, :console, format: "$time $metadata[$level] $message\n", metadata: [:request_id]
config :absinthe, log: false

config :logger, debug: true

config :money,
  default_currency: :USD

config :twitch,
  route_helpers: ClientWeb.Router.Helpers,
  endpoint: ClientWeb.Endpoint

# config :twitch,
# webhook_callback_url: ClientWeb.Router.Helpers.twitch_subscriptions_callback_url(
# ClientWeb.Endpoint,
# :callback
# )

################################################################################
# Emoncms config
################################################################################

config :emoncms,
  host: "https://emoncms.org",
  api_key: System.get_env("EMONCMS_API_KEY")

################################################################################
# Events config
################################################################################

config :event_bus, topics: [:chat_message, :twitch_event_created, :twitch_emote]

################################################################################
# Redis config
################################################################################

redis_uri =
  (System.get_env("REDIS_URL") || "redis://localhost:6379")
  |> URI.parse()

userinfo_without_user =
  if redis_uri.userinfo do
    redis_uri.userinfo |> String.trim_leading("h")
  else
    nil
  end

redis_url =
  %URI{redis_uri | userinfo: userinfo_without_user}
  |> URI.to_string()

config :redis, redis_url: redis_url

################################################################################
# Twitch config
################################################################################

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
