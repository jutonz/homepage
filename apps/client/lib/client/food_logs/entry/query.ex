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
        CURRENT_DATE + sequential_dates.date
      AS date
      FROM
        generate_series(0, 365)
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
    {:ok, result} =
      @by_day_fragment
      |> :io_lib.format([food_log_id])
      |> Client.Repo.query()

    Enum.group_by(
      result.rows,
      fn [date, _description] -> Ecto.Date.cast!(date) end,
      fn [_date, description] -> description end
    )
  end
end
