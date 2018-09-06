defmodule Client do
  @moduledoc """
  Client keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def base_url(extra \\ %{}) do
    parts =
      Application.get_env(:client, ClientWeb.Endpoint)[:url]
      |> Map.new()
      |> Map.merge(extra)

    struct(URI, parts) |> URI.to_string()
  end
end
