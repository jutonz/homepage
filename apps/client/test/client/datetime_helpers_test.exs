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

  describe "to_date/2" do
    test "reads a naive timestamp as UTC and answers in the given zone" do
      assert DateTimeHelpers.to_date(~N[2026-09-07 02:30:00], "America/New_York") ==
               ~D[2026-09-06]
    end

    test "answers the same date when the zone does not shift it across midnight" do
      assert DateTimeHelpers.to_date(~N[2026-09-07 16:30:00], "America/New_York") ==
               ~D[2026-09-07]
    end

    test "shifts a zoned datetime before reading its date" do
      assert DateTimeHelpers.to_date(~U[2026-01-01 03:00:00Z], "America/New_York") ==
               ~D[2025-12-31]
    end

    test "leaves a datetime already in the zone alone" do
      {:ok, dt} = DateTime.new(~D[2026-09-06], ~T[21:00:00], "America/New_York")
      assert DateTimeHelpers.to_date(dt, "America/New_York") == ~D[2026-09-06]
    end
  end
end
