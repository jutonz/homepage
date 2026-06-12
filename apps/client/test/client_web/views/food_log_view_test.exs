defmodule ClientWeb.FoodLogViewTest do
  use ExUnit.Case, async: true
  alias ClientWeb.FoodLogView

  describe "ordered_days/1" do
    test "orders dates from newest to oldest" do
      older = ~U[2025-03-13 00:00:00Z]
      newer = ~U[2025-03-14 00:00:00Z]
      newest = ~U[2025-03-15 00:00:00Z]

      entries = %{older => [], newest => [], newer => []}

      assert FoodLogView.ordered_days(entries) == [newest, newer, older]
    end

    test "is empty when there are no entries" do
      assert FoodLogView.ordered_days(%{}) == []
    end
  end
end
