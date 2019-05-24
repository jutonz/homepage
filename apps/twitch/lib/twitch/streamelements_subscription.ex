defmodule Twitch.StreamelementsSubscription do
  use WebSockex
  require Logger

  @thity_seconds 30_000

  def start_link([twitch_user, channel_name]) do
    channel_name = channel_name |> String.trim_leading("#")

    case Twitch.Api.Streamelements.jwt(twitch_user, channel_name) do
      {:ok, :not_enabled} ->
        :ignore

      {:ok, jwt} ->
        state = %{
          server: "wss://extension.streamelements.com/ws?token=#{jwt}"
        }

        opts = [
          # debug: [:trace],
          name: name(twitch_user, channel_name)
        ]

        WebSockex.start_link(state.server, __MODULE__, state, opts)
    end
  end

  def call(messages) when is_list(messages) do
    pid = self()

    spawn(fn ->
      messages |> Enum.each(&WebSockex.send_frame(pid, {:text, &1}))
    end)
  end

  def call(message), do: call([message])

  def ping, do: call("{\"type\": \"PING\"}")

  def handle_connect(_conn, state) do
    ping()
    schedule_ping()
    {:ok, state}
  end

  def schedule_ping do
    Process.send_after(self(), :ping, @thity_seconds)
  end

  def handle_info(:ping, state) do
    ping()
    schedule_ping()
    {:ok, state}
  end

  def handle_raw_message(_message) do
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

  def name(twitch_user, channel_name) do
    :"Twitch.StreamelementsSubscription:#{twitch_user.twitch_user_id}:#{channel_name}"
  end
end
