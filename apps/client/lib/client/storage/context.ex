defmodule Client.Storage.Context do
  use Ecto.Schema
  import Ecto.Changeset

  schema "storage_contexts" do
    belongs_to(:creator, Client.User)
    field(:name, :string)
    timestamps(type: :utc_datetime)

    many_to_many(
      :teams,
      Client.Team,
      join_through: "storage_context_teams",
      on_replace: :delete,
      on_delete: :delete_all
    )

    field(:team_names, {:array, :string}, virtual: true)
  end

  @required_params ~w[creator_id name]a
  @optional_params ~w[]a
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
