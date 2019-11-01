# Since configuration is shared in umbrella projects, this file
# should only configure the :twitch_web application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# General application configuration
config :twitch_web,
  ecto_repos: [Twitch.Repo],
  generators: [context_app: :twitch],
  live_view: [
    signing_salt: "GakYThHq3i8b2wE+W12iNNKrwEzMkq6d"
  ]

# Configures the endpoint
config :twitch_web, TwitchWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "CpbQNkENsODiEjJb8F2GdaOXvvNYFnppBbMlFDMSvkj1IgGixyo//br6oyH7EDx9",
  render_errors: [view: TwitchWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: TwitchWeb.PubSub, adapter: Phoenix.PubSub.PG2]

config :phoenix,
  template_engines: [leex: Phoenix.LiveView.Engine]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
