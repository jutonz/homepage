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

    headers = persistent_headers ++ user_headers |> Map.new |> Enum.to_list
    IO.inspect headers

    url = base_url() |> URI.merge(path) |> URI.to_string()

    case method do
      :get -> HTTPoison.get!(url, headers, params: params) |> parse_response()
      _ -> HTTPoison |> apply(method, [url, body, headers]) |> parse_response()
    end
  end

  def parse_response(response = %HTTPoison.Response{}) do
    IO.inspect response
    response.body |> Poison.decode!()
  end

  def base_url do
    "https://api.twitch.tv/kraken"
  end

  def client_id do
    Application.get_env(:twitch, :oauth)[:client_id]
  end

  def client_secret do
    Application.get_env(:twitch, :oauth)[:client_secret]
  end
end
