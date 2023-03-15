defmodule Client.Todoist.Response do
  require Logger

  @type t :: %__MODULE__{
          status: non_neg_integer() | nil,
          body: String.t() | nil,
          headers: Finch.Request.headers() | [],
          error: boolean()
        }

  defstruct status: nil,
            body: nil,
            headers: [],
            error: false

  @spec build({:ok, Finch.Response.t()} | {:error, Exception.t()}) :: t()
  def build({:ok, %{status: status} = response}) when status < 400 do
    parse_response(response)
  end

  def build({:ok, response}) do
    %{parse_response(response) | error: true}
  end

  def build(other) do
    Logger.info("Failed to make request to Todoist API: #{inspect(other)}")
    %__MODULE__{error: true}
  end

  defp parse_response(response) do
    case get_content_type(response) do
      "application/json" -> json_response(response)
      _ -> plain_response(response)
    end
  end

  @spec get_content_type(Finch.Response.t()) :: String.t()
  defp get_content_type(%{headers: headers}) do
    case List.keyfind(headers, "content-type", 0) do
      tuple when is_tuple(tuple) -> elem(tuple, 1)
      _ -> nil
    end
  end

  @http_attributes ~w[status body headers]a
  defp json_response(%{body: body} = response) do
    attrs =
      response
      |> Map.take(@http_attributes)
      |> Map.put(:body, Jason.decode!(body))

    struct!(%__MODULE__{}, attrs)
  end

  @spec plain_response(Finch.Response.t()) :: t()
  defp plain_response(response) do
    struct!(%__MODULE__{}, Map.take(response, @http_attributes))
  end
end
