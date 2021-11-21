defmodule Twitch.Api.Eventsub.Subscriptions do
  @moduledoc """
  https://dev.twitch.tv/docs/api/reference/#create-eventsub-subscription
  """
  alias Twitch.Api.Request

  @base_url "https://api.twitch.tv"
  @path "/helix/eventsub/subscriptions"

  def list do
    @base_url
    |> Request.build(@path, :get)
    |> Request.add_json_headers()
  end

  def create(body) do
    @base_url
    |> Request.build(@path, :post)
    |> Request.add_json_headers()
    |> Request.add_body(body)
  end

  def delete(id) do
    @base_url
    |> Request.build(@path, :delete)
    |> Request.add_url_params(%{id: id})
  end
end
