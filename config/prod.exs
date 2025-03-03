import Config

################################################################################
# Client config
################################################################################

config :client,
  env: :prod
  # file_renamer_path: "/data/home/jutonz/pictures/ios/t"

config :client, ClientWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json"
  # http: [port: 4080]
  # force_ssl: [hsts: true, rewrite_on: [:x_forwarded_proto], host: nil],
  # https: [
  #   port: 4443,
  #   cipher_suite: :strong,
  #   keyfile: "/home/jutonz/srv/homepage/secrets/privkey.pem",
  #   certfile: "/home/jutonz/srv/homepage/secrets/fullchain.pem"
  # ]

# Do not print debug messages in production
config :logger, level: :info

config :client, Client.Repo,
  adapter: Ecto.Adapters.Postgres,
  ssl: false

config :sentry,
  environment_name: :prod,
  enable_source_code_context: true,
  root_source_code_paths: [File.cwd!()],
  tags: %{
    env: "production"
  }

################################################################################
# Twitch config
################################################################################

config :twitch, Twitch.Repo,
  adapter: Ecto.Adapters.Postgres,
  ssl: false

twitch_users = [
  # ela
  "26921830",
  # syps_
  "86120737",
  # trizze
  "14824099",
  # comradenerdy
  "61350245"
]

config :twitch,
  eventsub_subscriptions:
    Enum.flat_map(twitch_users, fn user_id ->
      [
        %{
          type: "channel.update",
          condition: %{"broadcaster_user_id" => user_id},
          version: 1
        },
        %{
          type: "stream.online",
          condition: %{"broadcaster_user_id" => user_id},
          version: 1
        },
        %{
          type: "stream.offline",
          condition: %{"broadcaster_user_id" => user_id},
          version: 1
        }
      ]
    end)
