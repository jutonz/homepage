defmodule Twitch.Api.ClientCredentials do
  alias Twitch.Api.{
    Authentication,
    Request
  }

  @base_url "https://id.twitch.tv"
  @path "/oauth2/token"

  @spec create(list(String.t())) :: Request.t()
  def create(scopes) do
    params = %{
      "client_id" => Authentication.client_id(),
      "client_secret" => Authentication.client_secret(),
      "grant_type" => "client_credentials",
      "scope" => Enum.join(scopes, ",")
    }

    @base_url
    |> Request.build(@path, :post)
    |> Request.use_client_credentials()
    |> Request.add_url_params(params)
  end
end
