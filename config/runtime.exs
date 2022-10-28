import Config

################################################################################
# Client config
################################################################################

port = System.get_env("PORT") || "4000" |> String.to_integer()

host =
  case System.get_env("HEROKU_APP_NAME") do
    "jt-homepage" -> "app.jutonz.com"
    nil -> "app.jutonz.com"
    app -> "#{app}.herokuapp.com"
  end

config :client, ClientWeb.Endpoint,
  http: [port: port],
  url: [scheme: "https", port: 443, host: host],
  check_origin: ["https://#{host}"]

config :client, Client.Mailer,
  adapter: Bamboo.SendGridAdapter,
  api_key: {:system, "SENDGRID_API_KEY"}

db_url = System.get_env("DATABASE_URL")
db_pool_size = (System.get_env("POOL_SIZE") || "10") |> String.to_integer()

config :client, Client.Repo,
  url: db_url,
  pool_size: db_pool_size

config :sentry, dsn: {:system, "SENTRY_DSN"}
