use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :homepage, HomepageWeb.Endpoint,
  http: [port: 4000],
  url: [host: "0.0.0.0", port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [yarn: ["run", "watch",
                    cd: Path.expand("../assets", __DIR__)]]


# Watch static and templates for browser reloading.
config :homepage, HomepageWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/homepage_web/views/.*(ex)$},
      ~r{lib/homepage_web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :homepage, Homepage.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "docker",
  password: "docker",
  database: "homepage_dev",
  hostname: System.get_env("PG_HOST") || "psql",
  pool_size: 10
