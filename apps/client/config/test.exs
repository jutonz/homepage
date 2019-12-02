use Mix.Config

config :client, default_timezone: "Etc/UTC"

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
  password: nil

# Default capabilities copied from here:
# https://github.com/elixir-wallaby/wallaby/blob/master/lib/wallaby/experimental/chrome.ex#L74
config :wallaby,
  max_wait_time: 250,
  screenshot_on_failure: true,
  screenshot_dir: "/tmp/homepage-screenshots",
  driver: Wallaby.Experimental.Chrome,
  chromedriver: [
    capabilities: %{
      javascriptEnabled: true,
      loadImages: false,
      version: "",
      rotatable: false,
      takesScreenshot: true,
      cssSelectorsEnabled: true,
      nativeEvents: false,
      platform: "ANY",
      unhandledPromptBehavior: "accept",
      loggingPrefs: %{
        browser: "DEBUG"
      },
      chromeOptions: %{
        args: [
          "--no-sandbox",
          "window-size=1280,800",
          "--disable-gpu",
          "--headless",
          "--fullscreen",
          "--user-agent=Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36"
        ]
      }
    }
  ]
