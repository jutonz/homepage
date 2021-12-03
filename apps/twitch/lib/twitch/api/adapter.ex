defmodule Twitch.Api.Adapter do
  @callback request(HTTPoison.Request.t()) ::
              {:ok,
               HTTPoison.Response.t() | HTTPoison.AsyncResponse.t() | HTTPoison.MaybeRedirect.t()}
              | {:error, HTTPoison.Error.t()}
end
