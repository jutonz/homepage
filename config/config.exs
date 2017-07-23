# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :homepage,
  ecto_repos: [Homepage.Repo]

# Configures the endpoint
config :homepage, Homepage.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "9Z4EOxi6xe+P7ci7gSQn/Lqt4QIXinGJu+CW4YI0lQYaBzFfJsvLvMDm2B38ETM+",
  render_errors: [view: Homepage.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Homepage.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
