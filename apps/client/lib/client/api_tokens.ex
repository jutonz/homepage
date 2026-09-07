defmodule Client.ApiTokens do
  @moduledoc """
  The API tokens a user issues to call the API as themselves.

  Every read and write takes a `Client.Scope`. A token is owned by the user who
  created it, and only that user may list it, read it, or destroy it. The owner
  comes from the scope rather than from params, so a crafted form cannot issue
  a token against someone else's account.

  Reads come in two shapes. `get/2` answers `nil` for a token that is missing
  or someone else's; the bang variant raises `Ecto.NoResultsError`, which a
  controller turns into a 404.

  Looking a token up *by its value* is deliberately not here — see
  `Client.ApiTokens.Authentication`.
  """

  alias Client.ApiTokens.ApiToken
  alias Client.ApiTokens.Query
  alias Client.Repo
  alias Client.Scope

  def new_changeset,
    do: ApiToken.changeset(%ApiToken{})

  def list(%Scope{} = scope),
    do: ApiToken |> Query.owned_by(scope) |> Repo.all()

  def get(%Scope{} = scope, id),
    do: ApiToken |> Query.owned_by(scope) |> Repo.get(id)

  def get!(%Scope{} = scope, id),
    do: ApiToken |> Query.owned_by(scope) |> Repo.get!(id)

  def get_by_description(%Scope{} = scope, description) do
    ApiToken
    |> Query.owned_by(scope)
    |> Query.by_description(description)
    |> Repo.one()
  end

  def create(%Scope{} = scope, params) do
    %ApiToken{user_id: scope.user.id}
    |> ApiToken.changeset(params)
    |> Repo.insert()
  end

  def delete(%Scope{} = scope, id),
    do: scope |> get!(id) |> Repo.delete()
end
