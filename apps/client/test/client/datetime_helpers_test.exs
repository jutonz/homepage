defmodule Client.DateTimeHelpersTest do
  use ExUnit.Case, async: true
  alias Client.DateTimeHelpers

  describe "beginning_of_day/1" do
    test "zeroes out the time fields" do
      dt = ~U[2025-03-14 15:42:37.123456Z]
      assert DateTimeHelpers.beginning_of_day(dt) == ~U[2025-03-14 00:00:00.000000Z]
    end

    test "preserves the zone" do
      {:ok, dt} = DateTime.new(~D[2025-03-14], ~T[15:42:37], "America/New_York")
      result = DateTimeHelpers.beginning_of_day(dt)
      assert result.time_zone == "America/New_York"
      assert {result.hour, result.minute, result.second} == {0, 0, 0}
    end
  end

  describe "end_of_day/1" do
    test "sets the time fields to the last microsecond" do
      dt = ~U[2025-03-14 15:42:37.123456Z]
      assert DateTimeHelpers.end_of_day(dt) == ~U[2025-03-14 23:59:59.999999Z]
    end

    test "preserves the zone" do
      {:ok, dt} = DateTime.new(~D[2025-03-14], ~T[15:42:37], "America/New_York")
      result = DateTimeHelpers.end_of_day(dt)
      assert result.time_zone == "America/New_York"
      assert {result.hour, result.minute, result.second} == {23, 59, 59}
    end
  end
end
