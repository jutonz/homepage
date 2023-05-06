defmodule Twitch.Api.Kraken do
  alias Twitch.ApiCache

  def connection(method, path, opts \\ []) do
    default_opts = [body: "", headers: [], params: [], access_token: nil, cache: true]
    options = Keyword.merge(default_opts, opts) |> Enum.into(%{})

    %{
      body: body,
      headers: user_headers,
      params: params,
      access_token: access_token,
      cache: cache
    } = options

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
      :get ->
        if cache do
          cached_get(url, headers, params) |> parse_response()
        else
          HTTPoison.get!(url, headers, params: params) |> parse_response()
        end

      _ ->
        with {:ok, response} <- apply(HTTPoison, method, [url, body, headers]) do
          parse_response(response)
        end
    end
  end

  @api_cache_server Application.compile_env(:twitch, :api_cache_name)
  def cached_get(url, headers, params) do
    cache_key = ApiCache.cache_key([url, headers, params])

    case ApiCache.get(@api_cache_server, cache_key) do
      nil ->
        # Logger.info("😿 cache miss #{cache_key} #{url}")
        response = HTTPoison.get!(url, headers, params: params)
        ApiCache.set(@api_cache_server, cache_key, response)
        response

      response ->
        # Logger.info("❗️ CACHE HIT #{cache_key} #{url}")
        response
    end
  end

  def parse_response(response = %HTTPoison.Response{}) do
    case response.body do
      "" -> ""
      body -> Jason.decode!(body)
    end
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
