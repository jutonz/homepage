defmodule Twitch.TwitchEmotes.Api do
  require Logger
  alias Twitch.ApiCache

  @one_minute 60000
  @one_hour @one_minute * 60

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

  def cached_get(url, headers, params) do
    cache_key = ApiCache.cache_key([url, headers, params])

    case ApiCache.get(cache_key) do
      nil ->
        Logger.info("😿 cache miss #{cache_key} #{url}")
        response = HTTPoison.get!(url, headers, params: params)
        ApiCache.set(cache_key, response, @one_hour)
        response

      response ->
        Logger.info("❗️ CACHE HIT #{cache_key} #{url}")
        response
    end
  end

  def parse_response(response = %HTTPoison.Response{}) do
    response.body |> Poison.decode!()
  end

  @api_base "https://api.twitchemotes.com"
  def api_base, do: @api_base
end
