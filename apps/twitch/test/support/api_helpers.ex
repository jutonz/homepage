defmodule Twitch.ApiTestHelpers do
  def reset_api_token_cache(_context) do
    ExUnit.Callbacks.on_exit(fn ->
      Twitch.Api.TokenCache.unset()
    end)

    :ok
  end

  def stub_auth_request do
    Twitch.HttpMock
    |> Mox.expect(:request, fn
      %{url: "https://id.twitch.tv/oauth2/token"} ->
        body = %{
          "access_token" => "access_token_abc123",
          "expires_in" => 5_387_394,
          "scope" => ["user:read:email"],
          "token_type" => "bearer"
        }

        response = %{body: JSON.encode!(body), status_code: 200}
        {:ok, response}
    end)
  end
end
