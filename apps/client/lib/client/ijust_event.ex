defmodule Client.IjustEvent do
  use Ecto.Schema
  import Ecto.Changeset
  alias Client.{IjustOccurrence, IjustEvent, Repo}

  @type t :: %__MODULE__{}
  @moduledoc false

  schema "ijust_events" do
    field(:name, :string)
    field(:count, :integer, default: 1)
    field(:ijust_context_id, :id)
    timestamps()
  end

  def changeset(%IjustEvent{} = event, attrs \\ %{}) do
    event
    |> cast(attrs, [:name, :count, :ijust_context_id])
    |> validate_required([:name, :count, :ijust_context_id])
    |> foreign_key_constraint(:ijust_context_id)
    |> unique_constraint(:name)
  end

  @spec get_for_context(String.t(), String.t()) :: {:ok, IjustEvent.t()} | {:error, String.t()}
  def get_for_context(context_id, event_id) do
    ev = IjustEvent |> Repo.get_by(ijust_context_id: context_id, id: event_id)

    case ev do
      %IjustEvent{} = ev -> {:ok, ev}
      _ -> {:error, "Could not find matching event"}
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
      |> Ecto.Multi.run(:ijust_occurrence, fn %{ijust_event: event} ->
        event.id |> new_occurrence_changeset |> Repo.insert()
      end)
      |> Repo.transaction()

    {:ok, event}
  end

  @spec add_occurrence(IjustEvent.t()) :: IjustEvent.t()
  def add_occurrence(event) do
    {:ok, %{ijust_event: event}} =
      Ecto.Multi.new()
      |> Ecto.Multi.insert(:ijust_occurrence, new_occurrence_changeset(event.id))
      |> Ecto.Multi.update(:ijust_event, inc_count_changeset(event))
      |> Repo.transaction()

    {:ok, event}
  end

  @spec new_occurrence_changeset(IjustEvent.t()) :: Ecto.Changeset.t()
  def inc_count_changeset(%IjustEvent{} = event) do
    event |> changeset(%{count: event.count + 1})
  end

  @spec new_occurrence_changeset(String.t()) :: Ecto.Changeset.t()
  def new_occurrence_changeset(event_id) when is_integer(event_id) do
    %IjustOccurrence{}
    |> IjustOccurrence.changeset(%{ijust_event_id: event_id})
  end
end
