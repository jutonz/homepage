use Mix.Config

# For development, we disable any cache and enable debugging and code
# reloading.
#
# The watchers configuration can be used to run external watchers to your
# application. For example, we use it with brunch.io to recompile .js and .css
# sources.
config :client, ClientWeb.Endpoint,
  http: [port: 4000],
  url: [host: "localhost", port: 4000, scheme: "http"],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [yarn: ["run", "watch", cd: Path.expand("../assets", __DIR__)]]

# Watch static and templates for browser reloading.
config :client, ClientWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/client_web/views/.*(ex)$},
      ~r{lib/client_web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
pg_host = System.get_env("PG_HOST") || "psql"

config :client, Client.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "docker",
  password: "docker",
  database: "homepage_dev",
  hostname: pg_host,
  pool_size: 10
