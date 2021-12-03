defmodule Twitch.ApiClient do
  alias Twitch.Api.{
    Authentication,
    Request,
    Response
  }

  def make_request(request) do
    request
    |> authorize()
    |> execute()
    |> respond()
  end

  defp authorize(%Request{token_type: :bearer} = request) do
    case Authentication.get_access_token() do
      {:ok, token} -> %{request | token: token}
      {:error, reason} -> %{request | error: reason}
    end
  end

  defp authorize(request) do
    request
  end

  defp execute(%Request{error: nil} = request) do
    request
    |> Request.authorize()
    |> Request.to_http_request()
    |> execute(request, http_executor())
  end

  defp execute(request) do
    request
  end

  defp execute(http_request, request, executor) do
    case apply(executor, :request, [http_request]) do
      {:ok, response} -> %{request | response: response}
      {:error, error} -> %{request | error: error}
    end
  end

  defp respond(%Request{} = request),
    do: request |> Response.from_request() |> respond()

  defp respond(%Response{code: code} = response) when code >= 200 and code < 300,
    do: {:ok, response}

  defp respond(%Response{} = response),
    do: {:error, response}

  def http_executor do
    Application.fetch_env!(:twitch, :http_executor)
  end
end
