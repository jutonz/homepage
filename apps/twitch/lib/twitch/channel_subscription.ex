defmodule Twitch.ChannelSubscription do
  use WebSockex
  require Logger

  def start_link([channel, oauth_token]) do
    state = %{
      server: "wss://irc-ws.chat.twitch.tv",
      pass: "oauth:#{oauth_token}",
      nick: "_syps",
      channel: channel
    }

    opts = [
      # debug: [:trace],
      name: __MODULE__
    ]

    WebSockex.start_link(state.server, __MODULE__, state, opts)
  end

  def call(message) do
    WebSockex.send_frame(self(), {:text, message})
  end

  def handle_connect(_conn, state) do
    Logger.debug("Connected :)")

    pid = self()

    spawn(fn ->
      WebSockex.send_frame(
        pid,
        {:text, "CAP REQ :twitch.tv/tags twitch.tv/commands twitch.tv/membership"}
      )

      WebSockex.send_frame(pid, {:text, "PASS #{state.pass}"})
      WebSockex.send_frame(pid, {:text, "NICK #{state.nick}"})
      WebSockex.send_frame(pid, {:text, "USER #{state.nick} 8 * :#{state.nick}"})
      WebSockex.send_frame(pid, {:text, "JOIN #{state.channel}"})
    end)

    {:ok, state}
  end

  def handle_frame({_type, msg}, state) do
    case Twitch.TwitchEvent.parse(msg, state.channel) do
      {:ok, parsed} ->
        Twitch.TwitchProducer.publish(parsed)

      {:error, reason} ->
        Logger.debug("Could not parse message (#{reason}), so it was skipped: #{msg}")
    end

    {:ok, state}
  end

  def handle_cast({:send, {type, msg} = frame}, state) do
    IO.puts("Sending #{type} frame with payload: #{msg}")
    {:reply, frame, state}
  end
end
