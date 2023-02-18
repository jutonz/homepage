defmodule Emoncms do
  @host Application.compile_env(:emoncms, :host)
  @api_key Application.compile_env(:emoncms, :api_key)
  @timezone "America/New_York"

  def get_values(feed_id \\ "380936") do
    {:ok, raw_values} = values_from_emoncms(feed_id)

    parsed =
      raw_values
      |> Enum.map(fn [timestamp, value] ->
        [
          unix_milliseconds_to_datetime(timestamp),
          value
        ]
      end)

    {:ok, parsed}
  end

  def values_from_emoncms(feed_id) do
    url = @host <> "/feed/data.json"
    headers = Emoncms.headers() ++ [accept: "application/json"]

    query = [
      id: feed_id,
      interval: 3600,
      start: start_time(),
      end: end_time()
    ]

    {:ok, resp} = HTTPoison.get(url, headers, params: query)

    case resp.status_code do
      200 -> {:ok, Poison.decode!(resp.body)}
      _ -> {:error, resp}
    end
  end

  def start_time do
    Timex.now()
    |> Timex.shift(days: -1)
    |> Timex.to_datetime()
    |> DateTime.to_unix(:millisecond)
  end

  def end_time do
    Timex.now()
    |> Timex.to_datetime()
    |> DateTime.to_unix(:millisecond)
  end

  def unix_milliseconds_to_datetime(unix) do
    timezone = Timex.Timezone.get(@timezone)

    unix
    |> DateTime.from_unix!(:millisecond)
    |> Timex.Timezone.convert(timezone)
  end

  def headers do
    [authorization: "Bearer #{@api_key}"]
  end
end
