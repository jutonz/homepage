defmodule Client.IjustContext do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]
  alias Client.{User, IjustEvent, IjustContext, Repo}

  schema "ijust_contexts" do
    timestamps()
    field(:name, :string)

    belongs_to(:user, User)
    has_many(:ijust_events, IjustEvent)
  end

  def changeset(%IjustContext{} = context, attrs \\ %{}) do
    context
    |> cast(attrs, [:name])
    |> validate_required(:name)
    |> unique_constraint(:name)
  end

  def get_for_user(context_id, user_id) do
    case IjustContext |> Repo.get_by(id: context_id, user_id: user_id) do
      %IjustContext{} = context -> {:ok, context}
      _ -> {:error, "No matching context"}
    end
  end

  def get_default_context(%User{} = user) do
    context = IjustContext |> Repo.get_by(name: "default", user_id: user.id)

    case context do
      %IjustContext{} -> {:ok, context}
      nil -> user |> create_default_context
    end
  end

  def create_default_context(%User{} = user) do
    cset =
      %IjustContext{}
      |> changeset(%{name: "default"})
      |> put_assoc(:user, user)

    cset |> Repo.insert()
  end

  def recent_events(context_id, limit \\ 10) do
    query =
      from(
        ev in IjustEvent,
        where: ev.ijust_context_id == ^context_id,
        order_by: ev.updated_at,
        limit: ^limit
      )

    {:ok, query |> Repo.all()}
  end
end
