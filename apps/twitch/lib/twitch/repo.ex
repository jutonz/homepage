defmodule Twitch.Repo do
  use Ecto.Repo,
    otp_app: :twitch,
    adapter: Ecto.Adapters.Postgres
end
