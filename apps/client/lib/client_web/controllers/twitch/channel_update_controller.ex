defmodule ClientWeb.Twitch.ChannelUpdateController do
  use ClientWeb, :controller

  alias Twitch.{
    Api,
    Eventsub.ChannelUpdates
  }

  def index(conn, params) do
    updates =
      params["channel_id"]
      |> twitch_id()
      |> ChannelUpdates.list_by_user_id()

    render(conn, "index.html", updates: updates)
  end

  defp twitch_id(channel_name) do
    with {:ok, %{data: data}} <- Api.user(channel_name),
         %{"data" => [data]} <- data do
      data["id"]
    else
      _ -> nil
    end
  end
end
