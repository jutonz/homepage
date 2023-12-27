defmodule ClientWeb.Twitch.ChatView do
  use Phoenix.LiveView,
    container: {:div, class: "grow overflow-scroll"}

  def render(assigns) do
    ClientWeb.Twitch.ChannelView.render("chat.html", assigns)
  end

  def mount(_params, %{"channel_name" => channel_name} = _session, socket) do
    topic = "chat_message:##{channel_name}"
    :ok = Phoenix.PubSub.subscribe(Client.PubSub, topic)

    socket =
      socket
      |> assign(events: [welcome_event(channel_name)])
      |> assign(channel_name: channel_name)
      |> assign(alive?: Twitch.ChatSubscription.alive?(channel_name))
      |> stream(:events, [], limit: 500)

    schedule_alive_check()

    {:ok, socket, temporary_assigns: [events: []]}
  end

  @valid_irc_commands ~w[PRIVMSG ACTION]
  def handle_info(%Twitch.ParsedEvent{} = event, socket) do
    if Enum.member?(@valid_irc_commands, event.irc_command) do
      IO.inspect(event)
      {:noreply, stream_insert(socket, :events, event)}
    else
      {:noreply, socket}
    end
  end

  def handle_info(:check_alive, socket) do
    channel_name = socket.assigns[:channel_name]
    is_alive = Twitch.ChatSubscription.alive?(channel_name)
    schedule_alive_check()
    {:noreply, assign(socket, alive?: is_alive)}
  end

  defp welcome_event(channel_name) do
    %Twitch.ParsedEvent{id: "welcome", message: "Connected to #{channel_name}'s chat"}
  end

  defp schedule_alive_check do
    Process.send_after(self(), :check_alive, 30_000)
  end
end
