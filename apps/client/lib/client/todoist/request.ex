defmodule Client.Todoist.Request do
  @moduledoc """
  Mostly just a wrapper for Finch calls, plus some convenience stuff.
  """

  @type t :: Finch.Request.t()

  alias Client.Todoist.Response

  defdelegate build(method, url), to: Finch

  def request(request) do
    request
    |> Finch.request(ClientFinch)
    |> Response.build()
  end

  def put_json_body(request, body) do
    request
    |> put_header("content-type", "application/json")
    |> Map.put(:body, JSON.encode!(body))
  end

  @spec put_auth_header(Finch.Request.t()) :: Finch.Request.t()
  def put_auth_header(request) do
    token = Application.fetch_env!(:client, :todoist_api_token)
    put_header(request, "authorization", "Bearer #{token}")
  end

  @spec put_json_header(Finch.Request.t()) :: Finch.Request.t()
  def put_json_header(request) do
    put_header(request, "accept", "application/json")
  end

  @spec put_header(Finch.Request.t(), String.t(), String.t()) :: Finch.Request.t()
  def put_header(request, key, value) do
    put_headers(request, [{key, value}])
  end

  @spec put_headers(Finch.Request.t(), Finch.Request.headers()) :: Finch.Request.t()
  def put_headers(%{headers: existing_headers} = request, headers) do
    # TODO: consider force downcasing the header key
    new_headers =
      Enum.reduce(existing_headers, headers, fn {key, _value} = header, headers ->
        List.keystore(headers, key, 0, header)
      end)

    %{request | headers: new_headers}
  end
end
