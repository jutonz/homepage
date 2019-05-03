defmodule Twitch.StreamelementsSubscription do
  use WebSockex
  require Logger

  def start_link([twitch_user, channel_name]) do
    channel_name = channel_name |> String.trim_leading("#")

    case Twitch.Api.Streamelements.jwt(twitch_user, channel_name) do
      {:ok, :not_enabled} ->
        :ignore

      {:ok, jwt} ->
        state = %{
          jwt: jwt,
          server: "wss://extension.streamelements.com/ws?token=#{jwt}"
        }

        opts = [
          debug: [:trace],
          name: name(twitch_user, channel_name)
        ]

        IO.inspect("CONNECTING FOR CHANNEL #{channel_name} WITH JWT #{jwt}")
        WebSockex.start_link(state.server, __MODULE__, state, opts)
    end
  end

  def handle_connect(_conn, state) do
    {:ok, state}
  end

  def handle_raw_message(message) do
    IO.inspect(message)
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
