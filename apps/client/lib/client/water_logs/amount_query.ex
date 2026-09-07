defmodule Client.WaterLogs.AmountQuery do
  @moduledoc """
  Helper module for querying the amount of water that has been dispensed by a
  water filter.
  """

  alias Client.Repo
  alias Client.Scope
  alias Client.WaterLogs.Entry

  @type opts :: [start_at: DateTime.t(), end_at: DateTime.t() | nil]
  @spec get_amount_dispensed(Scope.t(), String.t(), opts()) :: non_neg_integer()
  def get_amount_dispensed(%Scope{} = scope, log_id, opts) do
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

    get_amount_dispensed(scope, log_id, start_at, end_at)
  end

  @spec get_amount_dispensed(Scope.t(), String.t(), DateTime.t(), DateTime.t()) ::
          non_neg_integer()
  defp get_amount_dispensed(%Scope{} = scope, log_id, start_at, end_at) do
    query =
      Entry
      |> Entry.Query.owned_by(scope)
      |> Entry.Query.in_log(log_id)
      |> Entry.Query.dispensed_between(start_at, end_at)
      |> Entry.Query.total_ml()

    case Repo.one(query) do
      nil -> 0
      amount -> amount
    end
  end
end
