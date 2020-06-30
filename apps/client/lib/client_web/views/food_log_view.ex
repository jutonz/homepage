defmodule ClientWeb.FoodLogView do
  use ClientWeb, :view

  def ordered_days(entries),
    do: entries |> Map.keys() |> Enum.sort(&(Timex.compare(&1, &2) == 1))
end
