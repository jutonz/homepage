defmodule Twitch.GothConfig do
  use Goth.Config

  def init(config) do
    datastore_creds =
      "DATASTORE_CREDENTIALS_JSON"
      |> System.get_env()
      |> Base.decode64!()

    config_with_creds = config |> Keyword.put(:json, datastore_creds)

    {:ok, config_with_creds}
  end
end
