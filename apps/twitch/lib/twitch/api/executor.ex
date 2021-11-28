defmodule Twitch.Api.Executor do
  @behaviour Twitch.Api.Adapter

  def request(request) do
    HTTPoison.request(request)
  end
end
