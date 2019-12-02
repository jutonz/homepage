defmodule Client.FoodLogs.Entry.Query do
  import Ecto.Query, only: [from: 2]

  def by_log(query, log_id),
    do: from(entry in query, where: entry.food_log_id == ^log_id)

  @by_day_fragment """
  SELECT
    sequential_dates.date,
    food_log_entries.description
  FROM
    (
      SELECT
        '~s'::date + sequential_dates.date
      AS date
      FROM
        generate_series(0, ~B)
      AS sequential_dates(date)
    ) sequential_dates
  LEFT JOIN
    food_log_entries
  ON
    food_log_entries.occurred_at::date = sequential_dates.date
  WHERE
    food_log_entries.food_log_id = '~s'
  ORDER BY
    food_log_entries.occurred_at
  """
  def grouped_by_day(food_log_id) do
    {:ok, now_est} = DateTime.now("EST")
    start_date = now_est |> DateTime.to_date() |> to_string()
    num_days = 30

    {:ok, result} =
      @by_day_fragment
      |> :io_lib.format([start_date, num_days, food_log_id])
      |> Client.Repo.query()

    Enum.group_by(
      result.rows,
      fn [date, _description] -> Ecto.Date.cast!(date) end,
      fn [_date, description] -> description end
    )
  end
end
