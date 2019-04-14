defmodule Twitch.Api.Kraken do
  def connection(method, path, opts \\ []) do
    default_opts = [body: "", headers: [], params: [], access_token: nil]
    options = Keyword.merge(default_opts, opts) |> Enum.into(%{})
    %{body: body, headers: user_headers, params: params, access_token: access_token} = options

    persistent_headers = [
      {"Client-ID", client_id()},
      {"Accept", "application/vnd.twitchtv.v5+json"}
    ]

    persistent_headers =
      if access_token do
        [{"Authorization", "Bearer #{access_token}"} | persistent_headers]
      else
        persistent_headers
      end

    headers = (persistent_headers ++ user_headers) |> Map.new() |> Enum.to_list()

    url = base_url() |> URI.merge(path) |> URI.to_string()

    case method do
      :get -> HTTPoison.get!(url, headers, params: params) |> parse_response()
      _ -> HTTPoison |> apply(method, [url, body, headers]) |> parse_response()
    end
  end

  def parse_response(response = %HTTPoison.Response{}) do
    response.body |> Poison.decode!()
  end

  def base_url do
    "https://api.twitch.tv/kraken"
  end

  def client_id do
    System.get_env("TWITCH_CLIENT_ID")
  end

  def client_secret do
    System.get_env("TWITCH_CLIENT_SECRET")
  end
end
