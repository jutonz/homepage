defmodule Client.Ijust.Event do
  use Ecto.Schema
  import Ecto.Changeset
  alias Client.{Ijust,Repo}

  schema "ijust_events" do
    field(:name, :string)
    field(:count, :integer, default: 1)
    timestamps()
    belongs_to(:ijust_context, Ijust.Context)
    has_many(:ijust_occurrences, Ijust.Occurrence)
  end

  def changeset(%Ijust.Event{} = event, attrs \\ %{}) do
    event
    |> cast(attrs, [:name, :count])
    |> validate_required([:name, :count])
  end

  def add_for_user(context_id, user, args) do
    {:ok, name} = args |> Map.fetch(:name)
    existing = Ijust.Event |> Repo.get_by(name: name, ijust_context_id: context_id)

    case existing do
      %Ijust.Event{} = event -> event |> add_occurrence
      _ -> create_with_occurrence(context_id, user, args)
    end
  end

  def create_with_occurrence(context_id, user, args) do
    {:ok, context} = context_id |> Ijust.Context.get_for_user(user.id)

    cset = %Ijust.Event{}
           |> changeset(args)
           |> put_assoc(:user, user)
           |> put_assoc(:ijust_context, context)

    Ecto.Multi.new
    |> Ecto.Multi.insert(:ijust_event, cset)
    |> Ecto.Multi.run(:ijust_occurrence, fn(%{ijust_event: event}) ->
      event |> new_occurrence_changeset |> Repo.insert
    end)
    |> Repo.transaction
  end

  def add_occurrence(event) do
    Ecto.Multi.new
    |> Ecto.Multi.insert(:ijust_occurrence, new_occurrence_changeset(event))
    |> Ecto.Multi.update(:ijust_event, inc_count_changeset(event))
    |> Repo.transaction
  end

  def inc_count_changeset(%Ijust.Event{} = event) do
    event |> changeset(%{count: event.count + 1})
  end

  def new_occurrence_changeset(%Ijust.Event{} = event) do
    %Ijust.Occurrence{}
    |> Ijust.Occurrence.changeset
    |> put_assoc(:ijust_event, event)
  end
end
