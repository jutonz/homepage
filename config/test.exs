use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :homepage, Homepage.Endpoint,
  http: [port: 4000],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :homepage, Homepage.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "docker",
  password: "docker",
  database: "homepage_test",
  hostname: System.get_env("PG_HOST") || "psql",
  pool: Ecto.Adapters.SQL.Sandbox
