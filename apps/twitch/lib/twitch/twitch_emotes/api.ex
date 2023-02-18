defmodule Twitch.TwitchEmotes.Api do
  alias Twitch.ApiCache

  def connection(method, path, opts \\ []) do
    default_opts = [body: "", headers: [], params: []]
    options = Keyword.merge(default_opts, opts) |> Enum.into(%{})
    %{body: body, headers: headers, params: params} = options

    url = api_base() |> URI.merge(path) |> URI.to_string()

    case method do
      :get -> cached_get(url, headers, params) |> parse_response()
      _ -> HTTPoison |> apply(method, [url, body, headers]) |> parse_response()
    end
  end

  @one_minute 60000
  @one_hour @one_minute * 60
  @api_cache_server Application.compile_env(:twitch, :api_cache_name)
  def cached_get(url, headers, params) do
    cache_key = ApiCache.cache_key([url, headers, params])

    case ApiCache.get(@api_cache_server, cache_key) do
      nil ->
        response = HTTPoison.get!(url, headers, params: params)
        ApiCache.set(@api_cache_server, cache_key, response, @one_hour)
        response

      response ->
        response
    end
  end

  def parse_response(response = %HTTPoison.Response{}) do
    response.body |> Poison.decode!()
  end

  @api_base "https://api.twitchemotes.com"
  def api_base, do: @api_base
end
