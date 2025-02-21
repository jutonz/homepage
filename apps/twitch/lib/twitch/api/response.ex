defmodule Twitch.Api.Response do
  alias Twitch.Api.Request

  @type t :: %__MODULE__{
          code: integer() | :error | nil,
          data: map() | nil,
          request: Request.t() | nil
        }
  defstruct [:code, :data, :request]

  @spec from_request(Request.t()) :: __MODULE__.t()
  def from_request(request)

  def from_request(%{response: %{status_code: code, body: nil}, error: nil} = request),
    do: %__MODULE__{code: code, data: nil, request: request}

  def from_request(%{response: %{status_code: 404 = code, body: body}, error: nil} = request),
    do: %__MODULE__{code: code, data: body, request: request}

  def from_request(%{response: %{status_code: 204 = code}, error: nil} = request),
    do: %__MODULE__{code: code, data: nil, request: request}

  def from_request(%{response: %{status_code: code, body: body}, error: nil} = request),
    do: %__MODULE__{code: code, data: JSON.decode!(body), request: request}

  def from_request(%{response: %{status_code: code}, error: nil} = request),
    do: %__MODULE__{code: code, data: nil, request: request}

  def from_request(%{error: %{reason: reason}} = request),
    do: %__MODULE__{code: :error, data: %{reason: reason}, request: request}

  def from_request(request),
    do: %__MODULE__{code: nil, data: nil, request: request}
end
