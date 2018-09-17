defmodule Twitch.ChannelSubscription do
  use WebSockex
  require Logger

  def start_link([channel, twitch_user_id, name]) do
    {:ok, twitch_user} = Twitch.User.refresh_token(twitch_user_id)
    oauth_token = twitch_user.access_token["access_token"]

    state = %{
      server: "wss://irc-ws.chat.twitch.tv",
      pass: "oauth:#{oauth_token}",
      nick: twitch_user.display_name,
      channel: channel
    }

    opts = [
      # debug: [:trace],
      name: name
    ]

    WebSockex.start_link(state.server, __MODULE__, state, opts)
  end

  def call(messages) when is_list(messages) do
    pid = self()

    spawn(fn ->
      messages |> Enum.each(&WebSockex.send_frame(pid, {:text, &1}))
    end)
  end

  def call(message), do: call([message])

  def handle_connect(_conn, state) do
    Logger.debug("Connected :)")

    call([
      "CAP REQ :twitch.tv/commands twitch.tv/membership",
      "PASS #{state.pass}",
      "NICK #{state.nick}",
      "USER #{state.nick} 8 * :#{state.nick}",
      "JOIN #{state.channel}"
    ])

    {:ok, state}
  end

  def handle_raw_message(message) do
    case Twitch.ParsedEvent.from_raw(message) do
      {:ok, %Twitch.ParsedEvent{irc_command: "PING"}} ->
        call("PONG")

      {:ok, parsed} ->
        Twitch.TwitchProducer.publish(parsed)

      {:error, reason} ->
        Logger.debug(
          "Could not parse message (#{reason}), so it was skipped: #{inspect(message)}"
        )
    end
  end

  def handle_frame({_type, msg}, state) do
    msg
    |> String.split("\r\n")
    |> Enum.each(fn raw ->
      if String.length(raw) > 0 do
        handle_raw_message(raw)
      end
    end)

    # msg |> String.split("\r\n") |> Enum.each(&Twitch.ChannelSubscription.handle_raw_message(&1))
    {:ok, state}
  end

  def handle_cast({:send, {type, msg} = frame}, state) do
    IO.puts("Sending #{type} frame with payload: #{msg}")
    {:reply, frame, state}
  end
end
