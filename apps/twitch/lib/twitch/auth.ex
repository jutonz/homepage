defmodule Twitch.Auth do
  @scope "chat:read chat:edit channel:moderate"

  def authorize_url do
    query =
      %{
        client_id: client_id(),
        redirect_uri: redirect_uri(),
        response_type: "code",
        scope: @scope
      }
      |> URI.encode_query()

    uri =
      %URI{
        host: "id.twitch.tv",
        query: query,
        scheme: "https",
        path: "/oauth2/authorize"
      }
      |> URI.to_string()

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

    IO.inspect(response)

    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, decoded} = body |> Poison.decode()
        # TODO: Also confirm scope?
        {:ok, decoded["access_token"]}

      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        {:error, "#{status_code}: #{body}"}

      _ ->
        {:error, "nope"}
    end
  end

  def client_id do
    Application.get_env(:twitch, :oauth)[:client_id]
  end

  def client_secret do
    Application.get_env(:twitch, :oauth)[:client_secret]
  end

  def redirect_uri do
    Application.get_env(:twitch, :oauth)[:redirect_uri]
  end
end
