defmodule Twitch.GothConfig do
  use Goth.Config

  def init(config) do
    case System.get_env("TWITCH_DATASTORE_DISABLED") do
      "true" ->
        {:ok, config}

      _ ->
        datastore_creds =
          "DATASTORE_CREDENTIALS_JSON"
          |> System.get_env()
          |> Base.decode64!()

        config_with_creds = config |> Keyword.put(:json, datastore_creds)

        {:ok, config_with_creds}
    end
  end
end
