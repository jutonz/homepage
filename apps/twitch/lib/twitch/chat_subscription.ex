defmodule Twitch.ChatSubscription do
  use WebSockex
  require Logger

  def start_link(channel_name) do
    state = %{
      server: "wss://irc-ws.chat.twitch.tv",
      pass: "SCHMOOPIIE",
      nick: random_name(),
      channel: channel_name
    }

    opts = [
      # debug: [:trace],
      name: Twitch.Channel.chat_process_name(channel_name)
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
        Twitch.EventProducer.publish(parsed)

      {:error, reason} ->
        Twitch.EventParseFailureLogger.log(message, reason)
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

    {:ok, state}
  end

  def handle_cast({:send, {type, msg} = frame}, state) do
    IO.puts("Sending #{type} frame with payload: #{msg}")
    {:reply, frame, state}
  end

  defp random_name, do: "justinfan" <> to_string(:rand.uniform(9999))
end
