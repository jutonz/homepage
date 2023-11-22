defmodule Twitch.SevenTv.Api do
  @api_base "https://7tv.io"

  def connection(method, path, body \\ nil) do
    url = @api_base |> URI.merge(path) |> URI.to_string()

    method |>
      case do
        :get -> url |> HTTPoison.get!()
        _ -> HTTPoison |> apply(method, [url, body])
      end
      |> parse_response()
  end

  def parse_response(response = %HTTPoison.Response{}) do
    response.body |> Jason.decode!()
  end
end
