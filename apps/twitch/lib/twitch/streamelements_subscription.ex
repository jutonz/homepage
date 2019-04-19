defmodule Twitch.StreamelementsSubscription do
  use WebSockex
  require Logger

  def start_link([channel_name]) do
    jwt = Twitch.Api.Streamelements.jwt(channel_name)

    state = %{
      jwt: jwt
    }

    opts = [
      # debug: [:trace],
      name: name(channel_name)
    ]
  end

  def name(channel_name) do
  end
end
