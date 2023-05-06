defmodule Twitch.Bttv.Api do
  @api_base "https://api.betterttv.net/3/"

  def connection(method, path, body \\ nil) do
    url = @api_base |> URI.merge(path) |> URI.to_string()

    case method do
      :get -> HTTPoison.get!(url) |> parse_response()
      _ -> HTTPoison |> apply(method, [url, body]) |> parse_response()
    end
  end

  def parse_response(response = %HTTPoison.Response{}) do
    response.body |> Jason.decode!()
  end
end
