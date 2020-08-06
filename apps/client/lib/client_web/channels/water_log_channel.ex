defmodule ClientWeb.WaterLogChannel do
  alias Client.WaterLogs
  require Logger
  use Phoenix.Channel

  def join("water_log:" <> water_log_id, _msg, socket) do
    user_id = socket.assigns[:user_id]
    case WaterLogs.get_by_user_id(user_id, water_log_id) do
      nil -> {:error, %{"reason" => "no such water log"}}
      _log -> {:ok, socket}
    end
  end
end
