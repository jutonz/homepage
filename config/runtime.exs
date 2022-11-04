import Config

################################################################################
# Client config
################################################################################

port = "PORT" |> System.fetch_env!() |> String.to_integer()

host = System.fetch_env!("HOSTNAME")
  #case System.get_env("HEROKU_APP_NAME") do
    #"jt-homepage" -> "app.jutonz.com"
    #nil -> "app.jutonz.com"
    #app -> "#{app}.herokuapp.com"
  #end

config :client, ClientWeb.Endpoint,
  http: [port: port],
  url: [scheme: "https", port: 443, host: host],
  check_origin: ["https://#{host}"]

config :client, Client.Mailer,
  adapter: Bamboo.SendGridAdapter,
  api_key: {:system, "SENDGRID_API_KEY"}

db_pool_size = "POOL_SIZE" |> System.fetch_env!() |> String.to_integer()

config :client, Client.Repo,
  url: System.fetch_env!("DATABASE_URL"),
  pool_size: db_pool_size

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
  pool_size: db_pool_size
