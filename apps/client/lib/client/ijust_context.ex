defmodule Client.IjustContext do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]
  alias Client.{IjustEvent, IjustContext, Repo}

  @type t :: %__MODULE__{}
  @moduledoc false

  schema "ijust_contexts" do
    timestamps()
    field(:name, :string)
    field(:user_id, :id)
  end

  def changeset(%IjustContext{} = context, attrs \\ %{}) do
    context
    |> cast(attrs, [:name, :user_id])
    |> validate_required([:name, :user_id])
    |> unique_constraint(:name)
    |> foreign_key_constraint(:user_id)
  end

  @spec get_for_user(integer, integer) :: {:ok, IjustContext.t()} | {:error, String.t()}
  def get_for_user(context_id, user_id) do
    case IjustContext |> Repo.get_by(id: context_id, user_id: user_id) do
      %IjustContext{} = context -> {:ok, context}
      _ -> {:error, "No matching context"}
    end
  end

  @spec get_default_context(user_id :: number) :: {:ok, IjustContext.t()}
  def get_default_context(user_id) do
    context = IjustContext |> Repo.get_by(name: "default", user_id: user_id)

    case context do
      %IjustContext{} -> {:ok, context}
      nil -> user_id |> create_default_context
    end
  end

  @spec create_default_context(user_id :: number) :: {:ok, IjustContext.t()}
  def create_default_context(user_id) do
    %IjustContext{}
    |> changeset(%{name: "default", user_id: user_id})
    |> Repo.insert()
  end

  @spec recent_events(context_id :: number, limit :: number) :: {:ok, list(IjustEvent.t())}
  def recent_events(context_id, limit \\ 5) do
    query =
      from(
        ev in IjustEvent,
        where: ev.ijust_context_id == ^context_id,
        order_by: [desc: ev.updated_at],
        limit: ^limit
      )

    {:ok, query |> Repo.all()}
  end

  @spec get_by_user_id(number | String.t()) :: {:ok, list(IjustContext.t())} | {:error, String.t()}
  def get_by_user_id(user_id) do
    #contexts = IjustContext |> Repo.all(user_id: ^user_id)
    query = from(c in IjustContext, where: c.user_id == ^user_id, order_by: c.name)
    contexts = query |> Repo.all()

    if contexts == [] do
      {:ok, default} = user_id |> IjustContext.get_default_context()
      {:ok, [default]}
    else
      {:ok, contexts}
    end
  end
end
