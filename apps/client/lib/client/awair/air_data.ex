defmodule Client.Awair.AirData do
  use Ecto.Schema

  @derive {
    JSON.Encoder,
    only: ~w[
      abs_humid co2 co2_est co2_est_baseline dew_point humid pm10_est pm25
      score temp voc voc_baseline voc_ethanol_raw voc_h2_raw
    ]a
  }

  @primary_key false
  schema "air_data" do
    field(:abs_humid, :float)
    field(:co2, :float)
    field(:co2_est, :integer)
    field(:co2_est_baseline, :integer)
    field(:dew_point, :float)
    field(:humid, :float)
    field(:pm10_est, :integer)
    field(:pm25, :integer)
    field(:score, :integer)
    field(:temp, :float)
    field(:timestamp, :utc_datetime)
    field(:voc, :integer)
    field(:voc_baseline, :integer)
    field(:voc_ethanol_raw, :integer)
    field(:voc_h2_raw, :integer)
  end

  @req_options Application.compile_env(:client, :awair, [])[:req_options] || []
  @path "/air-data/latest"
  def latest(host) do
    [
      base_url: host,
      url: @path,
      retry: false
    ]
    |> Keyword.merge(@req_options)
    |> Req.request()
    |> parse_response()
  end

  def from_json(json) do
    fields = __MODULE__.__schema__(:fields)

    %__MODULE__{}
    |> Ecto.Changeset.cast(json, fields)
    |> Ecto.Changeset.apply_changes()
  end

  defp parse_response({:ok, %{body: body}}) do
    {:ok, from_json(body)}
  end

  defp parse_response({:error, %{reason: reason}}) do
    {:error, reason}
  end

  defp parse_response(resp), do: resp
end
