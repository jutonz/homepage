defmodule Client.DateTimeHelpers do
  @spec beginning_of_day(DateTime.t()) :: DateTime.t()
  def beginning_of_day(%DateTime{} = dt) do
    %{dt | hour: 0, minute: 0, second: 0, microsecond: {0, 6}}
  end

  @spec end_of_day(DateTime.t()) :: DateTime.t()
  def end_of_day(%DateTime{} = dt) do
    %{dt | hour: 23, minute: 59, second: 59, microsecond: {999_999, 6}}
  end

  @doc """
  The calendar date a moment falls on in `time_zone`.

  A naive timestamp is read as UTC, which is how Ecto stores one.
  """
  @spec to_date(DateTime.t() | NaiveDateTime.t(), Calendar.time_zone()) :: Date.t()
  def to_date(%DateTime{} = dt, time_zone),
    do: dt |> DateTime.shift_zone!(time_zone) |> DateTime.to_date()

  def to_date(%NaiveDateTime{} = naive, time_zone),
    do: naive |> DateTime.from_naive!("Etc/UTC") |> to_date(time_zone)
end
