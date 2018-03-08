use Mix.Config

# We don't run a server during test. If one is required, you can enable the
# server option below.
config :client, ClientWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
pg_host = System.get_env("PG_HOST") || "psql"

config :client, Client.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "docker",
  password: "docker",
  database: "homepage_test",
  hostname: pg_host,
  pool: Ecto.Adapters.SQL.Sandbox
