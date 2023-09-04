defmodule Client.Influx do
  require Logger

  @path "/api/v2/write"
  def write(line_data, bucket) do
    query = Plug.Conn.Query.encode(%{org: org(), bucket: bucket})
    url = host() <> @path <> "?" <> query
    body = Client.Influx.LineData.to_string(line_data)

    :post
    |> Finch.build(url, headers(), body)
    |> Finch.request(ClientFinch)
    |> handle_response()
  end

  def handle_response({:ok, %{status: 204} = resp}), do: {:ok, resp}

  def handle_response({:ok, %{status: status, body: body} = resp}) do
    Logger.warn("[#{__MODULE__}] Failed to write to InfluxDB (#{status}): #{IO.inspect(body)}")
    {:error, resp}
  end

  def handle_response({:error, %{status: status, body: body} = resp}) do
    Logger.warn("[#{__MODULE__}] Failed to write to InfluxDB (#{status}): #{IO.inspect(body)}")
    {:error, resp}
  end

  def handle_response({:error, err}) do
    Logger.warn("[#{__MODULE__}] Failed to write to InfluxDB (unknown)")
    {:error, err}
  end

  defp config, do: Application.get_env(:client, :influx)
  defp host, do: config()[:host]
  defp org, do: config()[:org]
  defp token, do: config()[:token]

  defp headers do
    [
      {"authorization", "Token #{token()}"},
      {"content-type", "text/plain"},
    ]
  end
end
