defmodule ClientWeb.WaterLogViewTest do
  use ClientWeb.ConnCase, async: true
  alias ClientWeb.WaterLogView

  describe "formatted_date/1" do
    test "renders in the configured timezone with the day/month/year/time format" do
      dt = ~U[2025-03-14 15:00:00Z]
      assert WaterLogView.formatted_date(dt) == "14 Mar 2025 11:00"
    end

    test "treats a NaiveDateTime as UTC (matches Ecto timestamps())" do
      naive = ~N[2025-03-14 15:00:00]
      assert WaterLogView.formatted_date(naive) == "14 Mar 2025 11:00"
    end
  end
end
