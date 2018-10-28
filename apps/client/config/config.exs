# This file is responsible for configuring your application and its
# dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and is restricted to
# this project.
use Mix.Config

# General application configuration
config :client,
  namespace: Client,
  ecto_repos: [Client.Repo]

secret_key_base = System.get_env("SECRET_KEY_BASE") || "9Z4EOxi6xe+P7ci7gSQn/Lqt4QIXinGJu+CW4YI0lQYaBzFfJsvLvMDm2B38ETM+"

config :client, ClientWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: secret_key_base,
  render_errors: [view: ClientWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Client.PubSub, adapter: Phoenix.PubSub.PG2]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :absinthe, log: false

db_host = System.get_env("DB_HOST")
db_port = System.get_env("DB_PORT")
db_user = System.get_env("DB_USER")
db_pass = System.get_env("DB_PASS")
db_name = "homepage_" <> to_string(Mix.env())
db_pool_size = System.get_env("DB_POOL_SIZE") || "10" |> String.to_integer()

config :client, Client.Repo,
  adapter: Ecto.Adapters.Postgres,
  hostname: db_host,
  username: db_user,
  password: db_pass,
  port: db_port,
  database: db_name,
  pool_size: db_pool_size

# Guardian exists within Auth domain, but config must be done globally here.

# Import environment specific config. This must remain at the bottom of this
# file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
