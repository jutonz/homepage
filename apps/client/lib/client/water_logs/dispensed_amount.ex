defmodule Client.WaterLogs.DispensedAmount do
  @type t :: %__MODULE__{
          date: DateTime.t() | nil,
          amount: non_neg_integer() | nil,
          percentage: non_neg_integer() | nil
        }

  defstruct date: nil,
            amount: nil,
            percentage: nil

  @spec by_day(String.t(), DateTime.t(), DateTime.t()) :: list(__MODULE__.t())
  @by_day_fragment """
  SELECT
    (series.date AT TIME ZONE $1)::date AS date,
    COALESCE(SUM(entry.ml), 0) AS amount
  FROM
    GENERATE_SERIES($2, $3, '1 day'::interval) AS series(date)
  LEFT JOIN
    water_log_entries entry
  ON
    ((entry.inserted_at AT TIME ZONE 'Z') AT TIME ZONE $1)::date = series.date
    AND
    entry.water_log_id = $4
  GROUP BY
    series.date
  ORDER BY
    series.date
  """
  def by_day(log_id, start_at, end_at) do
    zone = start_at.time_zone
    start_at = DateTime.shift_zone!(start_at, "Etc/UTC")
    end_at = DateTime.shift_zone!(end_at, "Etc/UTC")
    {:ok, uuid} = Ecto.UUID.dump(log_id)

    response =
      Client.Repo.query!(
        @by_day_fragment,
        [zone, start_at, end_at, uuid]
      )

    amounts =
      Enum.map(response.rows, fn [date, amount] ->
        %__MODULE__{
          date: date,
          amount: amount
        }
      end)

    max_amount = amounts |> Enum.map(& &1.amount) |> Enum.max()

    Enum.map(amounts, fn amount ->
      percentage =
        if amount.amount == 0 do
          0
        else
          amount.amount / max_amount * 100
        end

      Map.put(amount, :percentage, percentage)
    end)
  end
end
