import Config

################################################################################
# Client config
################################################################################

config :client,
  default_timezone: "America/New_York"

# We don't run a server during test. If one is required, you can enable the
# server option below.
config :client, ClientWeb.Endpoint,
  http: [port: 4002],
  server: true

# Print only warnings and errors during test
config :logger, level: :warn

config :client, Client.Repo,
  adapter: Ecto.Adapters.Postgres,
  pool: Ecto.Adapters.SQL.Sandbox,
  database: "homepage_test",
  hostname: "localhost",
  username: "postgres",
  password: nil,
  ownership_timeout: :infinity,
  pool_size: 20

config :client, sql_sandbox: Client.Sandbox

# Default capabilities copied from here:
# https://github.com/elixir-wallaby/wallaby/blob/master/lib/wallaby/experimental/chrome.ex#L74
config :wallaby,
  otp_app: :client,
  max_wait_time: 3_000,
  screenshot_on_failure: true,
  screenshot_dir: "/tmp/homepage-screenshots",
  driver: Wallaby.Chrome,
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
  twitch_emotes_api_client: Twitch.TwitchEmotesApiMock

config :exenv,
  start_on_application: false,
  adapters: []
