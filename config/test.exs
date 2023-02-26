import Config

################################################################################
# Client config
################################################################################

config :client,
  env: :test,
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
  #log: :debug # enable to print ecto logs in test

config :client, sql_sandbox: Client.Sandbox

# Default capabilities copied from here:
# https://github.com/elixir-wallaby/wallaby/blob/master/lib/wallaby/experimental/chrome.ex#L74
config :wallaby,
  otp_app: :client,
  max_wait_time: 10_000,
  screenshot_on_failure: true,
  screenshot_dir: "/tmp/homepage-screenshots",
  driver: Wallaby.Chrome,
  chromedriver: [
    capabilities: %{
      takesScreenshot: true,
      loggingPrefs: %{
        browser: "DEBUG"
      },
      chromeOptions: %{
        args: [
          "--window-size=1920,1080",
          "--headless",
          # Enable software rendering using SwANGLE. When using --headless, we
          # don't get a GPU, but WebGL stuff (Three.js) needs one. I found I
          # needed this flag to get Three.js animations to work in tests on my
          # machine. Interestingly, this didn't seem necessary for CI. Maybe
          # something changed in recent chrome versions?
          # https://stackoverflow.com/a/73048626
          "--use-gl=angle",
        ]
      }
    }
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
