import Config

################################################################################
# Client config
################################################################################

port = System.get_env("PORT") || "4000" |> String.to_integer()

host =
  case System.get_env("HEROKU_APP_NAME") do
    "jt-homepage" -> "app.jutonz.com"
    nil -> "app.jutonz.com"
    app -> "#{app}.herokuapp.com"
  end

config :client, ClientWeb.Endpoint,
  http: [port: port],
  url: [scheme: "https", port: 443, host: host],
  cache_static_manifest: "priv/static/cache_manifest.json",
  force_ssl: [hsts: true, rewrite_on: [:x_forwarded_proto]],
  check_origin: ["https://#{host}"]

# Do not print debug messages in production
config :logger, level: :info

config :client, Client.Mailer,
  adapter: Bamboo.SendGridAdapter,
  api_key: {:system, "SENDGRID_API_KEY"}

db_url = System.get_env("DATABASE_URL")
db_pool_size = (System.get_env("POOL_SIZE") || "10") |> String.to_integer()

config :client, Client.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: db_url,
  pool_size: db_pool_size,
  ssl: true

config :sentry,
  dsn: {:system, "SENTRY_DSN"},
  environment_name: :prod,
  enable_source_code_context: true,
  root_source_code_path: File.cwd!(),
  tags: %{
    env: "production"
  },
  included_environments: [:prod]

################################################################################
# Twitch config
################################################################################

db_url = System.get_env("TWITCH_DATABASE_URL")
db_pool_size = (System.get_env("POOL_SIZE") || "10") |> String.to_integer()

config :twitch, Twitch.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: db_url,
  pool_size: db_pool_size,
  ssl: true

config :twitch,
  eventsub_subscriptions: [
    # ela
    %{
      type: "channel.update",
      condition: %{"broadcaster_user_id" => "26921830"},
      version: 1
    },
    %{
      type: "stream.online",
      condition: %{"broadcaster_user_id" => "26921830"},
      version: 1
    },
    %{
      type: "stream.offline",
      condition: %{"broadcaster_user_id" => "26921830"},
      version: 1
    },
    # syps_
    %{
      type: "channel.update",
      condition: %{"broadcaster_user_id" => "86120737"},
      version: 1
    },
    %{
      type: "stream.online",
      condition: %{"broadcaster_user_id" => "86120737"},
      version: 1
    },
    %{
      type: "stream.offline",
      condition: %{"broadcaster_user_id" => "86120737"},
      version: 1
    },
  ]
