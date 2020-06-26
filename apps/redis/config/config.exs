import Config

redis_uri =
  (System.get_env("REDIS_URL") || "redis://localhost:6379")
  |> URI.parse()

userinfo_without_user =
  if redis_uri.userinfo do
    redis_uri.userinfo |> String.trim_leading("h")
  else
    nil
  end

redis_url =
  %URI{redis_uri | userinfo: userinfo_without_user}
  |> URI.to_string()

config :redis, redis_url: redis_url
