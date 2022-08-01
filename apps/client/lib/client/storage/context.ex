defmodule Client.Storage.Context do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}

  schema "storage_contexts" do
    belongs_to(:creator, Client.User)
    has_many(:items, Client.Storage.Item)

    many_to_many(
      :teams,
      Client.Team,
      join_through: "storage_context_teams",
      on_replace: :delete,
      on_delete: :delete_all
    )

    field(:name, :string)
    field(:default_location, :string)
    timestamps(type: :utc_datetime)

    field(:team_names, {:array, :string}, virtual: true)
  end

  @required_params ~w[creator_id name]a
  @optional_params ~w[default_location]a
  @params @required_params ++ @optional_params

  def changeset(context, params) do
    context
    |> cast(params, @params)
    |> maybe_put_teams_assoc(params)
    |> validate_required(@required_params)
  end

  defp maybe_put_teams_assoc(changeset, params) do
    if params["teams"] do
      put_assoc(changeset, :teams, params["teams"])
    else
      changeset
    end
  end
end
