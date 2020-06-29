defmodule Client.FoodLogs.Entry.Query do
  import Ecto.Query, only: [from: 2]

  def by_ids(query, ids),
    do: from(entry in query, where: entry.id in ^ids)

  def by_log(query, log_id),
    do: from(entry in query, where: entry.food_log_id == ^log_id)

  @by_day_fragment """
  SELECT
    sequential_dates.date,
    food_log_entries.description,
    food_log_entries.id
  FROM
    (
      SELECT
        '~s'::date - sequential_dates.date
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
    {:ok, now} = DateTime.now(timezone())
    yesterday = now |> DateTime.add(60 * 60 * 24, :second)
    start_date = yesterday |> DateTime.to_date() |> to_string()
    num_days = 31

    {:ok, result} =
      @by_day_fragment
      |> :io_lib.format([start_date, num_days, food_log_id])
      |> to_string()
      |> Client.Repo.query()

    Enum.group_by(
      result.rows,
      fn [date, _description, _id] -> date end,
      fn [_date, description, id] -> %{description: description, id: Ecto.UUID.cast!(id)} end
    )
  end

  defp timezone,
    do: Application.get_env(:client, :default_timezone)
end
