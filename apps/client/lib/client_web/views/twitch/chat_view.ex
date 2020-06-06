defmodule ClientWeb.Twitch.ChatView do
  use Phoenix.LiveView

  def render(assigns) do
    ClientWeb.Twitch.ChannelView.render("chat.html", assigns)
  end

  def mount(_params, %{channel_name: channel_name} = _session, socket) do
    topic = "chat_message:##{channel_name}"
    :ok = Phoenix.PubSub.subscribe(Client.PubSub, topic)

    socket =
      socket
      |> assign(events: [welcome_event(channel_name)])
      |> assign(channel_name: channel_name)
      |> assign(alive?: Twitch.ChatSubscription.alive?(channel_name))

    schedule_alive_check()

    {:ok, socket}
  end

  def handle_info(%Twitch.ParsedEvent{} = event, socket) do
    new_events = append_event(event, socket.assigns.events)
    {:noreply, assign(socket, :events, new_events)}
  end

  def handle_info(:check_alive, socket) do
    channel_name = socket.assigns[:channel_name]
    is_alive = Twitch.ChatSubscription.alive?(channel_name)
    schedule_alive_check()
    {:noreply, assign(socket, alive?: is_alive)}
  end

  @history_size 50
  @valid_irc_commands ~w[PRIVMSG ACTION]
  defp append_event(event, events) do
    if Enum.member?(@valid_irc_commands, event.irc_command) do
      [event | Enum.take(events, @history_size - 1)]
    else
      events
    end
  end

  defp welcome_event(channel_name) do
    %Twitch.ParsedEvent{message: "Connected to #{channel_name}"}
  end

  defp schedule_alive_check do
    Process.send_after(self(), :check_alive, 30_000)
  end
end
