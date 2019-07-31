defmodule Twitch.TwitchEmotes.Api do
  def connection(method, path, opts \\ []) do
    default_opts = [body: "", headers: [], params: []]
    options = Keyword.merge(default_opts, opts) |> Enum.into(%{})
    %{body: body, headers: headers, params: params} = options

    url = api_base() |> URI.merge(path) |> URI.to_string()

    case method do
      :get -> HTTPoison.get!(url, headers, params: params) |> parse_response()
      _ -> HTTPoison |> apply(method, [url, body, headers]) |> parse_response()
    end
  end

  def parse_response(response = %HTTPoison.Response{}) do
    response.body |> Poison.decode!()
  end

  @api_base "https://api.twitchemotes.com"
  def api_base, do: @api_base
end
