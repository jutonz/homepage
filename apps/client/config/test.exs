use Mix.Config

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

config :wallaby,
  driver: Wallaby.Experimental.Chrome
