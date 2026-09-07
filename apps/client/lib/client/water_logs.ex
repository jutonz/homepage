defmodule Client.WaterLogs do
  @moduledoc """
  Water logs, the entries dispensed into them, and the filters fitted to them.

  Every read and write takes a `Client.Scope`. A log belongs to its owner, and
  an entry belongs to whoever owns the log it hangs off — the user id an entry
  carries is provenance, a record of who dispensed the water, and is never
  consulted for access. A filter carries no owner at all, so it resolves
  ownership through its parent log, and so is always addressed through it.

  Reads come in two shapes. `get/2` answers `nil` for a record that is missing
  or someone else's, which is what a LiveView mount and a channel join want: a
  raise there takes the process down with it. The bang variants raise
  `Ecto.NoResultsError`, which a controller turns into a 404.
  """

  alias Client.Repo
  alias Client.Scope
  alias Client.WaterLogs.AmountQuery
  alias Client.WaterLogs.DispensedAmount
  alias Client.WaterLogs.Entry
  alias Client.WaterLogs.Filter
  alias Client.WaterLogs.Query
  alias Client.WaterLogs.WaterLog

  def changeset(log, params \\ %{}),
    do: WaterLog.changeset(log, params)

  def entry_changeset(entry, params \\ %{}),
    do: Entry.changeset(entry, params)

  def filter_changeset(filter, params \\ %{}),
    do: Filter.changeset(filter, params)

  def new_changeset,
    do: changeset(%WaterLog{})

  def new_filter_changeset,
    do: filter_changeset(%Filter{})

  def create(%Scope{} = scope, params) do
    %WaterLog{user_id: scope.user.id}
    |> WaterLog.changeset(params)
    |> Repo.insert()
  end

  def list(%Scope{} = scope),
    do: WaterLog |> Query.owned_by(scope) |> Repo.all()

  def get(%Scope{} = scope, id),
    do: WaterLog |> Query.owned_by(scope) |> Repo.get(id)

  def get!(%Scope{} = scope, id),
    do: WaterLog |> Query.owned_by(scope) |> Repo.get!(id)

  def create_entry(%Scope{} = scope, log_id, params) do
    log = get!(scope, log_id)

    %Entry{water_log_id: log.id, user_id: scope.user.id}
    |> Entry.changeset(params)
    |> Repo.insert()
  end

  def list_entries(%Scope{} = scope, log_id) do
    Entry
    |> Entry.Query.owned_by(scope)
    |> Entry.Query.in_log(log_id)
    |> Entry.Query.newest_first()
    |> Repo.all()
  end

  def get_amount_dispensed(%Scope{} = scope, log_id, opts \\ []),
    do: AmountQuery.get_amount_dispensed(scope, log_id, opts)

  def get_amount_dispensed_by_day(%Scope{} = scope, log_id, start_at, end_at),
    do: DispensedAmount.by_day(scope, log_id, start_at, end_at)

  def create_filter(%Scope{} = scope, log_id, params) do
    log = get!(scope, log_id)

    %Filter{water_log_id: log.id}
    |> Filter.changeset(params)
    |> Repo.insert()
  end

  def get_filter(%Scope{} = scope, log_id, id),
    do: Filter |> filter_in_log(scope, log_id) |> Repo.get(id)

  def get_filter!(%Scope{} = scope, log_id, id),
    do: Filter |> filter_in_log(scope, log_id) |> Repo.get!(id)

  def get_current_filter(%Scope{} = scope, log_id) do
    Filter
    |> filter_in_log(scope, log_id)
    |> Filter.Query.most_recent()
    |> Repo.one()
  end

  def list_filters(%Scope{} = scope, log_id) do
    Filter
    |> filter_in_log(scope, log_id)
    |> Filter.Query.oldest_first()
    |> Repo.all()
  end

  def update_filter(%Scope{} = scope, log_id, id, params) do
    scope
    |> get_filter!(log_id, id)
    |> Filter.changeset(params)
    |> Repo.update()
  end

  def delete_filter(%Scope{} = scope, log_id, id),
    do: scope |> get_filter!(log_id, id) |> Repo.delete()

  defp filter_in_log(query, %Scope{} = scope, log_id) do
    query
    |> Filter.Query.owned_by(scope)
    |> Filter.Query.in_log(log_id)
  end
end
