defmodule Client.Ijust.Context do
  use Ecto.Schema
  import Ecto.Changeset
  alias Client.{User,Account,Ijust,Repo}

  @default_context %{ name: "default", id: "default" }

  schema "ijust_contexts" do
    timestamps()

    belongs_to :user, User
    belongs_to :account, Account
    has_many :ijust_events, Ijust.Event
  end

  def changeset(%Ijust.Context{} = context, attrs \\ %{}) do
    context 
    |> cast(attrs, [:name])
    |> validate_required(:name)
    |> unique_constraint(:name)
  end

  def get_for_user(%User{} = user) do
    case Ijust.Context |> Repo.get_by(user_id: user.id) do
      context = %Ijust.Context{} -> {:ok, context}
      _ -> {:ok, @default_context}
    end
  end
end
