defmodule ClientWeb.UserChannel do
  use Phoenix.Channel

  def join("user:" <> user_id, _params, socket) do
    send(self(), :after_join)
    socket = socket |> assign(:user_id, user_id)
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    #{:ok, _} =
      #Presence.track(socket, socket.assigns.user_id, %{
        #online_at: System.system_time(:seconds)
      #})

    socket |> push("message", %{message: "hello world"})

    {:noreply, socket}
  end
end
