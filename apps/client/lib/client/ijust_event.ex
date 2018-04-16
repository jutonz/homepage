defmodule Client.IjustEvent do
  use Ecto.Schema
  import Ecto.Changeset
  alias Client.{IjustContext, IjustOccurrence, IjustEvent, Repo}

  schema "ijust_events" do
    field(:name, :string)
    field(:count, :integer, default: 1)
    timestamps()
    belongs_to(:ijust_context, IjustContext)
    has_many(:ijust_occurrences, IjustOccurrence)
  end

  def changeset(%IjustEvent{} = event, attrs \\ %{}) do
    event
    |> cast(attrs, [:name, :count])
    |> validate_required([:name, :count])
  end

  def add_for_user(context_id, user, args) do
    {:ok, name} = args |> Map.fetch(:name)
    existing = IjustEvent |> Repo.get_by(name: name, ijust_context_id: context_id)

    case existing do
      %IjustEvent{} = event -> event |> add_occurrence
      _ -> create_with_occurrence(context_id, user, args)
    end
  end

  def create_with_occurrence(context_id, user, args) do
    {:ok, context} = context_id |> IjustContext.get_for_user(user.id)

    cset =
      %IjustEvent{}
      |> changeset(args)
      |> put_assoc(:ijust_context, context)

    {:ok, %{ijust_event: event}} =
      Ecto.Multi.new()
      |> Ecto.Multi.insert(:ijust_event, cset)
      |> Ecto.Multi.run(:ijust_occurrence, fn %{ijust_event: event} ->
        event |> new_occurrence_changeset |> Repo.insert()
      end)
      |> Repo.transaction()

    {:ok, event}
  end

  def add_occurrence(event) do
    {:ok, %{ijust_event: event}} =
      Ecto.Multi.new()
      |> Ecto.Multi.insert(:ijust_occurrence, new_occurrence_changeset(event))
      |> Ecto.Multi.update(:ijust_event, inc_count_changeset(event))
      |> Repo.transaction()

    {:ok, event}
  end

  def inc_count_changeset(%IjustEvent{} = event) do
    event |> changeset(%{count: event.count + 1})
  end

  def new_occurrence_changeset(%IjustEvent{} = event) do
    %IjustOccurrence{}
    |> IjustOccurrence.changeset()
    |> put_assoc(:ijust_event, event)
  end
end
