defmodule Client.Influx.LineData do
  defstruct measurement: nil,
            tags: %{},
            values: %{},
            timestamp: nil

  def to_string(line_data = %__MODULE__{}) do
    [
      "#{line_data.measurement},#{map_to_line(line_data.tags)}",
      map_to_line(line_data.values),
      format_timestamp(line_data.timestamp)
    ] |> Enum.join(" ")
  end

  # %{"one" => "1", "two" => "2"} becomes "one=1,two=2"
  defp map_to_line(map) do
    map
    |> Map.to_list()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&Enum.join(&1, "="))
    |> Enum.join(",")
  end

  defp format_timestamp(timestamp) do
    DateTime.to_unix(timestamp, :nanosecond)
  end
end
