defmodule Twitch.Api.Eventsub.Subscriptions do
  @moduledoc """
  https://dev.twitch.tv/docs/api/reference/#create-eventsub-subscription
  """
  alias Twitch.Api.Request

  @base_url "https://api.twitch.tv"
  @path "/helix/eventsub/subscriptions"

  def create(body) do
    @base_url
    |> Request.build(@path, :post)
    |> Request.add_json_headers()
    |> Request.add_body(body)
  end
end
