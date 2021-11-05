defmodule Twitch.Api.Authentication do
  alias Twitch.{
    Api.ClientCredentials,
    Api.TokenCache,
    ApiClient
  }

  def get_access_token do
    TokenCache.get()
    |> invalidate_expired()
    |> case do
      nil -> fetch_from_api()
      token -> {:ok, token["access_token"]}
    end
  end

  def client_id do
    System.fetch_env!("TWITCH_CLIENT_ID")
  end

  def client_secret do
    System.fetch_env!("TWITCH_CLIENT_SECRET")
  end

  @scopes ["user:read:email"]
  defp fetch_from_api do
    @scopes
    |> ClientCredentials.create()
    |> ApiClient.make_request()
    |> case do
      {:ok, %{data: data}} ->
        cache_token(data)
        {:ok, data["access_token"]}

      {:error, reason} ->
        {:error, "Could not fetch access token: #{reason}"}
    end
  end

  defp invalidate_expired(nil), do: nil

  defp invalidate_expired(%{"expires_at" => expires_at} = token) do
    if Time.compare(Time.utc_now(), expires_at) > 0 do
      token
    else
      nil
    end
  end

  defp cache_token(data) do
    now = Time.utc_now()
    expires_in_seconds = data["expires_in"]
    expires_at = Time.add(now, expires_in_seconds, :second)

    data
    |> Map.put("expires_at", expires_at)
    |> TokenCache.set()
  end
end
