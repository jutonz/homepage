import Config

################################################################################
# Client config
################################################################################

config :client,
  admin_username: "admin",
  admin_password: "admin",
  env: :dev

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
  check_origin: false

# Watch static and templates for browser reloading.
config :client, ClientWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(static-js|static-css|js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/client_web/views/.*(ex)$},
      ~r{lib/client_web/templates/.*(eex)$},
      ~r{lib/my_app_web/live/.*(ex)$}
    ]
  ],
  watchers: [
    yarn: [
      "bundle:js",
      cd: Path.expand("../apps/client/assets", __DIR__)
    ],
    yarn: [
      "bundle:css",
      "--watch",
      cd: Path.expand("../apps/client/assets", __DIR__)
    ],
    yarn: [
      "codegen",
      "--watch",
      cd: Path.expand("../apps/client/assets", __DIR__)
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

config :phoenix_live_view,
  debug_heex_annotations: true,
  debug_attributes: true,
  enable_expensive_runtime_checks: true

config :client, Client.Mailer, adapter: Bamboo.LocalAdapter

config :client, Client.Repo,
  database: "homepage_dev",
  hostname: "localhost"

config :sentry, environment_name: :dev

################################################################################
# Twitch config
################################################################################

config :twitch, Twitch.Repo,
  database: "homepage_twitch_dev",
  hostname: "localhost"

import_config "dev.secret.exs"
