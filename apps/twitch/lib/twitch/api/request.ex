defmodule Twitch.Api.Request do
  @type request_method :: :delete | :get | :post | :put
  @type token_type :: :bearer | :client_credentials
  @type t :: %__MODULE__{
          body: map,
          error: String.t() | map | nil,
          headers: map,
          method: request_method,
          params: map,
          base_url: String.t() | nil,
          path: String.t(),
          response: HTTPoison.Response.t() | nil,
          token: String.t() | nil,
          token_type: token_type()
        }

  defstruct body: %{},
            error: nil,
            headers: %{},
            method: :get,
            params: %{},
            path: nil,
            response: nil,
            token: nil,
            base_url: nil,
            token_type: :bearer

  alias Twitch.Api.Authentication

  def build(base_url, path, method) do
    %__MODULE__{base_url: base_url, path: path, method: method}
  end

  def add_url_params(%__MODULE__{params: existing_params} = request, params) do
    %{request | params: Enum.into(params, existing_params)}
  end

  def add_body(%__MODULE__{body: existing_body} = request, body) do
    %{request | body: Enum.into(body, existing_body)}
  end

  def add_headers(%{headers: existing_headers} = request, headers) do
    %{request | headers: Enum.into(headers, existing_headers)}
  end

  @json_headers %{
    "content-type" => "application/json",
    "accept" => "application/json"
  }
  def add_json_headers(%__MODULE{} = request) do
    add_headers(request, @json_headers)
  end

  def use_client_credentials(request) do
    %{request | token_type: :client_credentials}
  end

  def authorize(%{token: token} = request) when not is_nil(token) do
    headers = %{
      "Authorization" => "Bearer #{token}",
      "Client-Id" => Authentication.client_id()
    }

    add_headers(request, headers)
  end

  def authorize(request) do
    request
  end

  def to_http_request(request) do
    request
    |> ensure_data_types()
    |> transform_to_http_request()
  end

  defp ensure_data_types(%{headers: headers} = request) when is_map(headers) do
    ensure_data_types(%{request | headers: Map.to_list(headers)})
  end

  defp ensure_data_types(%{body: body} = request) when is_map(body) and map_size(body) == 0 do
    ensure_data_types(%{request | body: ""})
  end

  defp ensure_data_types(%{body: body} = request) when is_map(body) do
    ensure_data_types(%{request | body: JSON.encode!(body)})
  end

  defp ensure_data_types(request) do
    request
  end

  @http_attributes ~w[body headers method options params]a
  defp transform_to_http_request(%__MODULE__{} = request) do
    url = request.base_url <> request.path
    struct(%HTTPoison.Request{url: url}, Map.take(request, @http_attributes))
  end
end
