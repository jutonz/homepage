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
  default_timezone: "America/New_York",
  admin_username: System.get_env("ADMIN_USERNAME") || "admin",
  admin_password:
    System.get_env("ADMIN_PASSWORD") || :crypto.strong_rand_bytes(124) |> Base.encode64(),
  todoist_api_token: System.get_env("TODOIST_API_TOKEN"),
  file_renamer_path: nil

config :phoenix,
  json_library: Jason,
  template_engines: [leex: Phoenix.LiveView.Engine]

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    "9Z4EOxi6xe+P7ci7gSQn/Lqt4QIXinGJu+CW4YI0lQYaBzFfJsvLvMDm2B38ETM+"

config :client, ClientWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: secret_key_base,
  render_errors: [view: ClientWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: Client.PubSub,
  live_view: [
    signing_salt: "GakYThHq3i8b2wE+W12iNNKrwEzMkq6d"
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
  bttv_api_client: Twitch.Bttv.Api,
  twitch_emotes_api_client: Twitch.TwitchEmotes.Api,
  api_cache_name: :api_cache,
  eventsub_subscriptions: [],
  http_executor: Twitch.Api.Executor,
  oauth: %{
    client_id: System.get_env("TWITCH_CLIENT_ID"),
    client_secret: System.get_env("TWITCH_CLIENT_SECRET"),
    redirect_uri: System.get_env("TWITCH_REDIRECT_URI")
  }

config :exenv,
  adapters: [
    {Exenv.Adapters.Dotenv,
     [
       file: "apps/twitch/config/.env.enc",
       encryption: [master_key: "apps/twitch/config/master.key"]
     ]}
  ]

import_config "#{Mix.env()}.exs"
