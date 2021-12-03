defmodule Twitch.Api.Executor do
  @behaviour Twitch.Api.Adapter

  defdelegate request(request), to: HTTPoison
end
