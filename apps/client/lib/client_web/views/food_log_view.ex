defmodule ClientWeb.FoodLogView do
  use ClientWeb, :view

  def ordered_days(entries),
    do: entries |> Map.keys() |> Enum.sort({:desc, DateTime})
end
