import Config

config :client, todoist_api_token: "abc123"

config :twitch,
  oauth: %{
    client_id: nil,
    client_secret: nil,
    redirect_uri: nil
  },
  webhook_secret: nil
