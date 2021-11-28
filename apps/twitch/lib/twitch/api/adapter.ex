defmodule Twitch.Api.Adapter do
  @callback request(HTTPoison.Request.t()) :: HTTPoison.Response.t()
end
