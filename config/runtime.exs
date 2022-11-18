import Config

################################################################################
# Client config
################################################################################

host = System.fetch_env!("PHX_HOST")
  #case System.get_env("HEROKU_APP_NAME") do
    #"jt-homepage" -> "app.jutonz.com"
    #nil -> "app.jutonz.com"
    #app -> "#{app}.herokuapp.com"
  #end

config :client, ClientWeb.Endpoint,
  url: [scheme: "https", port: 443, host: host],
  check_origin: ["https://#{host}"]

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

config :sentry, dsn: {:system, "SENTRY_DSN"}

################################################################################
# Twitch config
################################################################################

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