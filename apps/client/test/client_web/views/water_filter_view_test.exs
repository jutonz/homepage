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
end
