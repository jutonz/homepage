import Config

if config_env() == :prod do
  ##############################################################################
  # Client config
  ##############################################################################

  config :client,
    admin_username: System.fetch_env!("ADMIN_USERNAME"),
    admin_password: System.fetch_env!("ADMIN_PASSWORD"),
    todoist_api_token: System.fetch_env!("TODOIST_API_TOKEN")

  host = System.fetch_env!("PHX_HOST")

  config :client, ClientWeb.Endpoint,
    url: [scheme: "https", port: 443, host: host],
    check_origin: ["https://#{host}"],
    secret_key_base: System.fetch_env!("SECRET_KEY_BASE")

  if System.get_env("PHX_SERVER") do
    config :client, ClientWeb.Endpoint, server: true
  end

  config :client, Client.Mailer,
    adapter: Bamboo.SendGridAdapter,
    api_key: {:system, "SENDGRID_API_KEY"}

  db_pool_size = "POOL_SIZE" |> System.fetch_env!() |> String.to_integer()
  maybe_ipv6 = if System.get_env("ECTO_IPV6"), do: [:inet6], else: []

  config :client, Client.Repo,
    url: System.fetch_env!("DATABASE_URL"),
    pool_size: db_pool_size,
    socket_options: maybe_ipv6

  config :client, Client.Guardian,
    secret_key: System.fetch_env!("JWT_SIGNING_KEY")

  config :client, :influx,
    host: System.get_env("INFLUXDB_HOST") || "http://localhost:8086",
    org: System.get_env("INFLUXDB_ORG") || "myorg",
    token: System.get_env("INFLUXDB_TOKEN")

  config :sentry,
    dsn: System.get_env("SENTRY_DSN")

  ##############################################################################
  # Twitch config
  ##############################################################################

  config :twitch,
    oauth: %{
      client_id: System.fetch_env!("TWITCH_CLIENT_ID"),
      client_secret: System.fetch_env!("TWITCH_CLIENT_SECRET"),
      redirect_uri: System.fetch_env!("TWITCH_REDIRECT_URI")
    },
    webhook_secret: System.fetch_env!("TWITCH_CLIENT_ID")

  config :twitch, Twitch.Repo,
    url: System.fetch_env!("TWITCH_DATABASE_URL"),
    pool_size: db_pool_size,
    socket_options: maybe_ipv6
end
