defmodule Client.WaterLogs.AmountQueryTest do
  use Client.DataCase, async: true
  alias Client.WaterLogs

  describe "get_amount_dispensed/2" do
    test "sums amounts between start and end date" do
      log = insert(:water_log)
      now = now()

      _old_entry =
        insert(:water_log_entry,
          water_log_id: log.id,
          inserted_at: Timex.shift(now, minutes: -30),
          ml: 1
        )

      _new_entry = insert(:water_log_entry, water_log_id: log.id, ml: 1)

      usage =
        WaterLogs.get_amount_dispensed(log.id,
          start_at: Timex.shift(now, minutes: -40),
          end_at: Timex.shift(now, minutes: -20)
        )

      assert usage == 1
    end

    test "end_at defaults to now" do
      log = insert(:water_log)
      now = now()

      insert(:water_log_entry,
        water_log_id: log.id,
        ml: 1,
        inserted_at: Timex.shift(now, minutes: -10)
      )

      usage =
        WaterLogs.get_amount_dispensed(log.id,
          start_at: Timex.shift(now, minutes: -20)
        )

      assert usage == 1
    end

    test "excludes entries from other logs" do
      my_log = insert(:water_log)
      now = now()
      insert(:water_log_entry, water_log_id: my_log.id, ml: 1)

      other_log = insert(:water_log)
      insert(:water_log_entry, water_log_id: other_log.id, ml: 1)

      usage =
        WaterLogs.get_amount_dispensed(my_log.id,
          start_at: Timex.shift(now, minutes: -10)
        )

      assert usage == 1
    end
  end

  defp timezone,
    do: Application.fetch_env!(:client, :default_timezone)

  defp now,
    do: DateTime.now!(timezone())
end
