import Config

################################################################################
# Client config
################################################################################

config :client,
  env: :test,
  default_timezone: "America/New_York",
  sql_sandbox: ClientWeb.Plugs.Sandbox

# We don't run a server during test. If one is required, you can enable the
# server option below.
config :client, ClientWeb.Endpoint,
  http: [port: 4002],
  server: true

log_level = "LOG_LEVEL" |> System.get_env("warn") |> String.to_atom()
config :logger, level: log_level

config :client, Client.Repo,
  adapter: Ecto.Adapters.Postgres,
  pool: Ecto.Adapters.SQL.Sandbox,
  database: "homepage_test",
  hostname: "localhost",
  username: "postgres",
  password: nil,
  ownership_timeout: :infinity,
  pool_size: 20

# log: :debug # enable to print ecto logs in test

config :wallaby,
  otp_app: :client,
  max_wait_time: 10_000,
  screenshot_on_failure: true,
  screenshot_dir: "/tmp/homepage-screenshots",
  driver: Wallaby.Chrome,
  js_errors: true,
  chromedriver: [
    headless: true
  ]

################################################################################
# Twitch config
################################################################################

config :twitch, Twitch.Repo,
  adapter: Ecto.Adapters.Postgres,
  pool: Ecto.Adapters.SQL.Sandbox,
  database: "homepage_twitch_test",
  hostname: "localhost",
  username: "postgres",
  password: nil,
  pool_size: 20

config :twitch,
  bttv_api_client: Twitch.BttvApiMock,
  twitch_emotes_api_client: Twitch.TwitchEmotesApiMock,
  webhook_secret: "secret",
  http_executor: Twitch.HttpMock,
  oauth: %{
    client_id: "TWITCH_CLIENT_ID",
    client_secret: "TWITCH_CLIENT_SECRET",
    redirect_uri: "TWITCH_REDIRECT_URI"
  }

config :exenv,
  start_on_application: false,
  adapters: []
