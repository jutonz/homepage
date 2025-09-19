defmodule ClientWeb.Twitch.ChannelUpdateController do
  use ClientWeb, :controller
  alias Twitch.{Api, Eventsub.ChannelUpdates}

  plug :put_view, ClientWeb.Twitch.ChannelUpdateView

  def index(conn, params) do
    case twitch_id(params["channel_id"]) do
      nil ->
        render(conn, "index_nouser.html")

      id ->
        updates = ChannelUpdates.list_by_user_id(id)
        render(conn, "index.html", updates: updates)
    end
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
