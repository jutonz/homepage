defmodule Client.FoodLogs do
  @moduledoc """
  Food logs and the entries kept in them.

  Every read and write takes a `Client.Scope`. A log belongs to its owner, and
  an entry belongs to whoever owns the log it hangs off — the user id an entry
  carries is provenance, a record of who logged the food, and is never
  consulted for access.

  Reads come in two shapes. `get/2` and `get_entry/2` answer `nil` for a record
  that is missing or someone else's, which is what a LiveView mount wants: a
  raise there kills the socket and the client reconnects into it. The bang
  variants raise `Ecto.NoResultsError`, which a controller turns into a 404.
  """

  alias Client.FoodLogs.Entry
  alias Client.FoodLogs.FoodLog
  alias Client.FoodLogs.Query
  alias Client.Repo
  alias Client.Scope

  def changeset(log, params \\ %{}),
    do: FoodLog.changeset(log, params)

  def entry_changeset(entry, params \\ %{}),
    do: Entry.changeset(entry, params)

  def new_changeset,
    do: FoodLog.changeset(%FoodLog{})

  def create(%Scope{} = scope, params) do
    %FoodLog{owner_id: scope.user.id}
    |> FoodLog.changeset(params)
    |> Repo.insert()
  end

  def list(%Scope{} = scope),
    do: FoodLog |> Query.owned_by(scope) |> Repo.all()

  def get(%Scope{} = scope, id),
    do: FoodLog |> Query.owned_by(scope) |> Repo.get(id)

  def get!(%Scope{} = scope, id),
    do: FoodLog |> Query.owned_by(scope) |> Repo.get!(id)

  def update(%Scope{} = scope, id, params) do
    scope
    |> get!(id)
    |> FoodLog.changeset(params)
    |> Repo.update()
  end

  def delete(%Scope{} = scope, id),
    do: scope |> get!(id) |> Repo.delete()

  def create_entry(%Scope{} = scope, log_id, params) do
    log = get!(scope, log_id)

    %Entry{food_log_id: log.id, user_id: scope.user.id}
    |> Entry.changeset(params)
    |> Repo.insert()
  end

  def get_entry(%Scope{} = scope, id),
    do: Entry |> Entry.Query.owned_by(scope) |> Repo.get(id)

  def get_entry!(%Scope{} = scope, id),
    do: Entry |> Entry.Query.owned_by(scope) |> Repo.get!(id)

  def get_entries(%Scope{} = scope, ids) do
    Entry
    |> Entry.Query.owned_by(scope)
    |> Entry.Query.by_ids(ids)
    |> Repo.all()
  end

  def list_entries_occurred_between(%Scope{} = scope, log_id, start_time, end_time) do
    Entry
    |> Entry.Query.owned_by(scope)
    |> Entry.Query.in_log(log_id)
    |> Entry.Query.occurred_between(start_time, end_time)
    |> Repo.all()
  end

  def update_entry(%Scope{} = scope, id, params) do
    scope
    |> get_entry!(id)
    |> Entry.changeset(params)
    |> Repo.update()
  end

  def delete_entry(%Scope{} = scope, id),
    do: scope |> get_entry!(id) |> Repo.delete()
end
