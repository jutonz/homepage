defmodule ClientWeb.Soap.BatchViewTest do
  use ClientWeb.ConnCase, async: true
  alias ClientWeb.Soap.BatchView

  describe "formatted_date/1" do
    test "renders in the configured timezone with the day/month/year/time format" do
      dt = ~U[2025-03-14 15:00:00Z]
      assert BatchView.formatted_date(dt) == "14 Mar 2025 11:00"
    end

    test "treats a NaiveDateTime as UTC (matches Ecto timestamps())" do
      naive = ~N[2025-03-14 15:00:00]
      assert BatchView.formatted_date(naive) == "14 Mar 2025 11:00"
    end
  end
end
