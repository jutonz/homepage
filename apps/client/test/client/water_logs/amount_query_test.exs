defmodule Client.WaterLogs.AmountQueryTest do
  use Client.DataCase, async: true
  alias Client.WaterLogs

  setup do
    scope = build(:scope)
    %{scope: scope, log: insert(:water_log, user_id: scope.user.id)}
  end

  describe "get_amount_dispensed/3" do
    test "sums amounts between start and end date", %{scope: scope, log: log} do
      now = now()

      _old_entry =
        insert(:water_log_entry,
          water_log_id: log.id,
          inserted_at: DateTime.shift(now, minute: -30),
          ml: 1
        )

      _new_entry = insert(:water_log_entry, water_log_id: log.id, ml: 1)

      usage =
        WaterLogs.get_amount_dispensed(scope, log.id,
          start_at: DateTime.shift(now, minute: -40),
          end_at: DateTime.shift(now, minute: -20)
        )

      assert usage == 1
    end

    test "end_at defaults to now", %{scope: scope, log: log} do
      now = now()

      insert(:water_log_entry,
        water_log_id: log.id,
        ml: 1,
        inserted_at: DateTime.shift(now, minute: -10)
      )

      usage =
        WaterLogs.get_amount_dispensed(scope, log.id, start_at: DateTime.shift(now, minute: -20))

      assert usage == 1
    end

    test "excludes entries from other logs", %{scope: scope, log: log} do
      now = now()
      insert(:water_log_entry, water_log_id: log.id, ml: 1)

      other_log = insert(:water_log, user_id: scope.user.id)
      insert(:water_log_entry, water_log_id: other_log.id, ml: 1)

      usage =
        WaterLogs.get_amount_dispensed(scope, log.id, start_at: DateTime.shift(now, minute: -10))

      assert usage == 1
    end

    test "is zero for another user's log", %{scope: scope} do
      now = now()
      other_log = insert(:water_log)
      insert(:water_log_entry, water_log_id: other_log.id, ml: 1)

      usage =
        WaterLogs.get_amount_dispensed(scope, other_log.id,
          start_at: DateTime.shift(now, minute: -10)
        )

      assert usage == 0
    end
  end

  defp timezone do
    Application.fetch_env!(:client, :default_timezone)
  end

  defp now do
    timezone() |> DateTime.now!() |> DateTime.shift_zone!("Etc/UTC")
  end
end
