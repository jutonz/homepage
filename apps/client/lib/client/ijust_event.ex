defmodule Client.IjustEvent do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]
  alias Client.{User, IjustContext, IjustOccurrence, IjustEvent, Repo}

  @type t :: %__MODULE__{}
  @moduledoc false

  @derive {Jason.Encoder, only: ~w[id name count ijust_context_id]a}

  schema "ijust_events" do
    belongs_to(:ijust_context, IjustContext)
    has_many(:ijust_occurrences, IjustOccurrence)

    field(:name, :string)
    field(:count, :integer, default: 1)
    field(:cost, Money.Ecto.Amount.Type)

    timestamps()
  end

  def changeset(%IjustEvent{} = event, attrs \\ %{}) do
    event
    |> cast(attrs, [:name, :count, :cost, :ijust_context_id])
    |> validate_required([:name, :count, :ijust_context_id])
    |> foreign_key_constraint(:ijust_context_id)
    |> unique_constraint(:name, name: "ijust_events_ijust_context_id_name_index")
  end

  def update_changeset(%IjustEvent{} = event, attrs \\ %{}) do
    event
    |> cast(attrs, [:name, :cost])
    |> validate_required([:name])
    |> unique_constraint(:name, name: "ijust_events_ijust_context_id_name_index")
  end

  @spec get_for_user(User.t(), String.t()) :: {:ok, IjustEvent.t()} | {:error, String.t()}
  def get_for_user(user, event_id) do
    query =
      from(
        e in IjustEvent,
        join: c in IjustContext,
        on: c.id == e.ijust_context_id,
        where: c.user_id == ^user.id,
        where: e.id == ^event_id
      )

    case Repo.one(query) do
      %IjustEvent{} = ev -> {:ok, ev}
      _ -> {:error, "Could not find matching event"}
    end
  end

  @spec get_by_id(String.t()) :: {:ok, IjustEvent.t()} | {:error, String.t()}
  def get_by_id(event_id) do
    case event = IjustEvent |> Repo.get(event_id) do
      %IjustEvent{} -> {:ok, event}
      _ -> {:error, "No matching event"}
    end
  end

  def add_for_user(user, args) do
    {:ok, name} = args |> Map.fetch(:name)
    {:ok, context_id} = args |> Map.fetch(:ijust_context_id)
    existing = IjustEvent |> Repo.get_by(name: name, ijust_context_id: context_id)

    case existing do
      %IjustEvent{} = event -> event |> add_occurrence
      _ -> create_with_occurrence(user, args)
    end
  end

  def create_with_occurrence(_user, args) do
    cset = %IjustEvent{} |> changeset(args)

    {:ok, %{ijust_event: event}} =
      Ecto.Multi.new()
      |> Ecto.Multi.insert(:ijust_event, cset)
      |> Ecto.Multi.run(:ijust_occurrence, fn _repo, %{ijust_event: event} ->
        event.id |> new_occurrence_changeset |> Repo.insert()
      end)
      |> Repo.transaction()

    {:ok, event}
  end

  @spec add_occurrence(IjustEvent.t()) :: {:ok, IjustEvent.t()}
  def add_occurrence(event) do
    {:ok, %{ijust_event: event}} =
      Ecto.Multi.new()
      |> Ecto.Multi.insert(:ijust_occurrence, new_occurrence_changeset(event.id))
      |> Ecto.Multi.update(:ijust_event, inc_count_changeset(event))
      |> Repo.transaction()

    {:ok, event}
  end

  def delete_occurrence(occ_id) do
    occ = IjustOccurrence |> Repo.get!(occ_id)

    occ_count =
      from(
        occ in IjustOccurrence,
        where: occ.ijust_event_id == ^occ.ijust_event_id,
        select: count(occ.id)
      )
      |> Repo.one()

    {:ok, _occ} = occ |> Repo.delete()

    if occ_count <= 1 do
      event = IjustEvent |> Repo.get!(occ.ijust_event_id)
      {:ok, _event} = event |> Repo.delete()
    end

    {:ok, occ}
  end

  def add_occurrence_by_id(event_id) do
    {:ok, event} = event_id |> IjustEvent.get_by_id()

    {:ok, %{ijust_occurrence: occurrence}} =
      Ecto.Multi.new()
      |> Ecto.Multi.insert(:ijust_occurrence, new_occurrence_changeset(event.id))
      |> Ecto.Multi.update(:ijust_event, inc_count_changeset(event))
      |> Repo.transaction()

    {:ok, occurrence}
  end

  @spec search_by_name(String.t(), String.t()) ::
          {:ok, list(IjustEvent.t())} | {:error, String.t()}
  def search_by_name(context_id, name) do
    like = "%" <> name <> "%"

    query =
      from(
        ev in IjustEvent,
        where: ev.ijust_context_id == ^context_id,
        where: ilike(ev.name, ^like),
        limit: 10
      )

    {:ok, Repo.all(query)}
  end

  @spec inc_count_changeset(IjustEvent.t()) :: Ecto.Changeset.t()
  def inc_count_changeset(%IjustEvent{} = event) do
    event |> changeset(%{count: event.count + 1})
  end

  @spec new_occurrence_changeset(integer) :: Ecto.Changeset.t()
  def new_occurrence_changeset(event_id) when is_integer(event_id) do
    %IjustOccurrence{}
    |> IjustOccurrence.changeset(%{ijust_event_id: event_id})
  end
end
