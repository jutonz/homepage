defmodule Client.WaterLogs.AmountQuery do
  @moduledoc """
  Helper module for querying the amount of water that has been dispensed by a
  water filter.
  """

  import Ecto.Query, only: [from: 2]
  alias Client.Repo
  alias Client.WaterLogs.Entry

  @type opts :: [start_at: DateTime.t(), end_at: DateTime.t() | nil]
  @spec get_amount_dispensed(String.t(), opts()) :: non_neg_integer()
  def get_amount_dispensed(log_id, opts) do
    now =
      :client
      |> Application.fetch_env!(:default_timezone)
      |> DateTime.now!()

    start_at =
      opts
      |> Keyword.fetch!(:start_at)
      |> DateTime.shift_zone!("Etc/UTC")

    end_at =
      opts
      |> Keyword.get(:end_at, now)
      |> DateTime.shift_zone!("Etc/UTC")

    get_amount_dispensed(log_id, start_at, end_at)
  end

  @spec get_amount_dispensed(String.t(), DateTime.t(), DateTime.t()) ::
          non_neg_integer()
  defp get_amount_dispensed(log_id, start_at, end_at) do
    query =
      from(
        entry in Entry,
        where: entry.water_log_id == ^log_id,
        where: entry.inserted_at >= ^start_at,
        where: entry.inserted_at <= ^end_at,
        select: sum(entry.ml)
      )

    case Repo.one(query) do
      nil -> 0
      amount -> amount
    end
  end
end
