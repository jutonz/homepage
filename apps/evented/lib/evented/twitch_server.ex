defmodule Evented.TwitchServer do
  use WebSockex
  require Logger

  def start_link() do
    state = %{
      server: "wss://irc-ws.chat.twitch.tv",
      pass: nil,
      nick: "sypsbot9000",
      channel: "#ninja"
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
    # {:ok, token} = Evented.Twitch.get_token()
    token = "jmf2uj92pq949300z38v59p56kmjob"
    state = state |> Map.put(:pass, "oauth:#{token}")

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
    case Evented.Twitch.parse(msg, state.channel) do
      {:ok, parsed} ->
        Evented.TwitchProducer.publish(parsed)

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
