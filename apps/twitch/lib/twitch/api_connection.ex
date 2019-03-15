defmodule Twitch.ApiConnection do
  def connection(access_token, method, path, opts \\ []) do
    default_opts = [body: "", headers: []]
    options = Keyword.merge(opts, default_opts) |> Enum.into(%{})
    %{body: body, headers: user_headers} = options

    persistent_headers = [
      {"Authorization", "Bearer #{access_token}"},
      {"Accept", "application/json"}
    ]

    headers = user_headers ++ persistent_headers

    url = base_url() |> URI.merge(path) |> URI.to_string()

    case method do
      :get -> HTTPoison |> apply(method, [url, headers]) |> parse_response()
      _ -> HTTPoison |> apply(method, [url, body, headers]) |> parse_response()
    end
  end

  def parse_response({:ok, response = %HTTPoison.Response{}}) do
    response.body |> Poison.decode()
  end

  def base_url do
    "https://api.twitch.tv"
  end
end
