defmodule Twitch.Auth do
  @scope "chat:read chat:edit channel:moderate user:read:email"

  def authorize_url do
    query =
      %{
        client_id: client_id(),
        redirect_uri: redirect_uri(),
        response_type: "code",
        scope: @scope
      }
      |> URI.encode_query()

    uri = "https://id.twitch.tv/oauth2/authorize?" <> query

    {:ok, uri}
  end

  def exchange(code) do
    query = %{
      client_id: client_id(),
      client_secret: client_secret(),
      redirect_uri: redirect_uri(),
      grant_type: "authorization_code",
      code: code
    }

    headers = [
      {"Accept", "application/json"}
    ]

    response =
      HTTPoison.post(
        "https://id.twitch.tv/oauth2/token",
        "",
        headers,
        params: query
      )

    response |> parse_response
  end

  def refresh(refresh_token) do
    query = %{
      grant_type: "refresh_token",
      refresh_token: refresh_token,
      client_id: client_id(),
      client_secret: client_secret()
    }

    headers = [
      {"Accept", "application/json"}
    ]

    response =
      HTTPoison.post(
        "https://id.twitch.tv/oauth2/token",
        "",
        headers,
        params: query
      )

    response |> parse_response
  end

  def parse_response(response) do
    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, decoded} = body |> Jason.decode()
        # TODO: Also confirm scope?
        {:ok, decoded}

      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        {:error, "#{status_code}: #{body}"}

      _ ->
        {:error, "nope"}
    end
  end

  def client_id do
    System.get_env("TWITCH_CLIENT_ID")
  end

  def client_secret do
    System.get_env("TWITCH_CLIENT_SECRET")
  end

  def redirect_uri do
    System.get_env("TWITCH_REDIRECT_URI")
  end
end
