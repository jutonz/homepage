defmodule ClientWeb.Twitch.ChatView do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <div class="chat">
      <div class="chat__messages">
        <%= for event <- @events do %>
          <p class="chat__messages__message">
            <%= event.display_name %>: <%= event.message %>
          </p>
        <% end %>
      </div>
    </div>
    """
  end

  def mount(%{channel_name: channel_name} = _session, socket) do
    topic = "chat_message:##{channel_name}"
    :ok = Phoenix.PubSub.subscribe(Client.PubSub, topic)
    {:ok, assign(socket, events: [welcome_event(channel_name)])}
  end

  def handle_info(%Twitch.ParsedEvent{} = event, socket) do
    new_events = append_event(event, socket.assigns.events)
    {:noreply, assign(socket, :events, new_events)}
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
end
