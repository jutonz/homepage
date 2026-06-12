defmodule Client.DateTimeHelpers do
  @spec beginning_of_day(DateTime.t()) :: DateTime.t()
  def beginning_of_day(%DateTime{} = dt) do
    %{dt | hour: 0, minute: 0, second: 0, microsecond: {0, 6}}
  end

  @spec end_of_day(DateTime.t()) :: DateTime.t()
  def end_of_day(%DateTime{} = dt) do
    %{dt | hour: 23, minute: 59, second: 59, microsecond: {999_999, 6}}
  end
end
