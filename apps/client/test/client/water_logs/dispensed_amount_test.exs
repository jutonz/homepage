defmodule Client.WaterLogs.DispensedAmountTest do
  use Client.DataCase, async: true
  alias Client.WaterLogs.DispensedAmount

  describe "by_day/3" do
    test "returns usage grouped by day" do
      log = insert(:water_log)
      end_of_today = end_of_today()

      beginning_of_yesterday =
        end_of_today
        |> Timex.shift(hours: -30)
        |> Timex.beginning_of_day()

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
            beginning_of_yesterday |> Timex.end_of_day() |> DateTime.shift_zone!("Etc/UTC"),
          ml: 1
        )

      _today_entry =
        insert(:water_log_entry,
          water_log_id: log.id,
          inserted_at: Timex.shift(end_of_today, hours: -3),
          ml: 1
        )

      dispensed_amount =
        DispensedAmount.by_day(
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

    test "sums entries for only the specified log" do
      my_log = insert(:water_log)
      not_my_log = insert(:water_log)
      end_of_today = end_of_today()
      beginning_of_today = end_of_today |> Timex.beginning_of_day()

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
  end

  defp timezone do
    "America/New_York"
  end

  defp end_of_today do
    timezone() |> DateTime.now!() |> Timex.end_of_day()
  end
end
