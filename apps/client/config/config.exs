# This file is responsible for configuring your application and its
# dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and is restricted to
# this project.
use Mix.Config

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

# General application configuration
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

# Import environment specific config. This must remain at the bottom of this
# file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
