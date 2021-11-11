defmodule Twitch.Api.Streams do
  alias Twitch.Api.Request

  @base_url "https://api.twitch.tv"
  @path "/helix/streams"

  def list_by_login(logins) when is_list(logins) do
    request = Request.build(@base_url, @path, :get)

    Enum.reduce(logins, request, fn login, request ->
      Request.add_url_params(request, %{user_login: login})
    end)
  end

  def list_by_login(login) do
    list_by_login([login])
  end
end
