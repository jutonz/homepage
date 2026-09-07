defmodule Client.WaterLogs.DispensedAmountTest do
  use Client.DataCase, async: true
  alias Client.DateTimeHelpers
  alias Client.WaterLogs.DispensedAmount

  setup do
    scope = build(:scope)
    %{scope: scope, log: insert(:water_log, user_id: scope.user.id)}
  end

  describe "by_day/4" do
    test "returns usage grouped by day", %{scope: scope, log: log} do
      end_of_today = end_of_today()

      beginning_of_yesterday =
        end_of_today
        |> DateTime.shift(hour: -30)
        |> DateTimeHelpers.beginning_of_day()

      _first_yesterday_entry =
        insert(:water_log_entry,
          water_log_id: log.id,
          inserted_at: beginning_of_yesterday |> DateTime.shift_zone!("Etc/UTC"),
          ml: 1
        )

      _second_yesterday_entry =
        insert(:water_log_entry,
          water_log_id: log.id,
          inserted_at:
            beginning_of_yesterday
            |> DateTimeHelpers.end_of_day()
            |> DateTime.shift_zone!("Etc/UTC"),
          ml: 1
        )

      _today_entry =
        insert(:water_log_entry,
          water_log_id: log.id,
          inserted_at: DateTime.shift(end_of_today, hour: -3),
          ml: 1
        )

      dispensed_amount =
        DispensedAmount.by_day(
          scope,
          log.id,
          beginning_of_yesterday,
          end_of_today
        )

      assert [
               %DispensedAmount{
                 amount: 2,
                 percentage: 100.0,
                 date: DateTime.to_date(beginning_of_yesterday)
               },
               %DispensedAmount{amount: 1, percentage: 50.0, date: DateTime.to_date(end_of_today)}
             ] == dispensed_amount
    end

    test "sums entries for only the specified log", %{scope: scope, log: my_log} do
      not_my_log = insert(:water_log, user_id: scope.user.id)
      end_of_today = end_of_today()
      beginning_of_today = end_of_today |> DateTimeHelpers.beginning_of_day()

      _my_entry =
        insert(:water_log_entry,
          water_log_id: my_log.id,
          inserted_at: beginning_of_today |> DateTime.shift_zone!("Etc/UTC"),
          ml: 1
        )

      _not_my_entry =
        insert(:water_log_entry,
          water_log_id: not_my_log.id,
          inserted_at: beginning_of_today |> DateTime.shift_zone!("Etc/UTC"),
          ml: 1
        )

      dispensed_amount =
        DispensedAmount.by_day(
          scope,
          my_log.id,
          beginning_of_today,
          end_of_today
        )

      assert [
               %DispensedAmount{
                 amount: 1,
                 percentage: 100.0,
                 date: DateTime.to_date(beginning_of_today)
               }
             ] == dispensed_amount
    end

    test "excludes entries on another user's log", %{scope: scope} do
      not_my_log = insert(:water_log)
      end_of_today = end_of_today()
      beginning_of_today = end_of_today |> DateTimeHelpers.beginning_of_day()

      insert(:water_log_entry,
        water_log_id: not_my_log.id,
        inserted_at: beginning_of_today |> DateTime.shift_zone!("Etc/UTC"),
        ml: 1
      )

      dispensed_amount =
        DispensedAmount.by_day(
          scope,
          not_my_log.id,
          beginning_of_today,
          end_of_today
        )

      assert [%DispensedAmount{amount: 0}] = dispensed_amount
    end
  end

  defp timezone do
    "America/New_York"
  end

  defp end_of_today do
    timezone() |> DateTime.now!() |> DateTimeHelpers.end_of_day()
  end
end
