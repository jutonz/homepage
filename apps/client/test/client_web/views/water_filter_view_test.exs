defmodule ClientWeb.WaterFilterViewTest do
  use ClientWeb.ConnCase, async: true
  alias ClientWeb.WaterFilterView

  describe "formatted_lifespan/1" do
    test "appends L" do
      assert WaterFilterView.formatted_lifespan(123) == "123 L"
    end

    test "is - when the lifespan is nil" do
      assert WaterFilterView.formatted_lifespan(nil) == "-"
    end
  end

  describe "formatted_date/1" do
    test "renders in the configured timezone with the day/month/year/time format" do
      dt = ~U[2025-03-14 15:00:00Z]
      assert WaterFilterView.formatted_date(dt) == "14 Mar 2025 11:00"
    end
  end
end
