defmodule Client.ApiTokens do
  alias Client.ApiTokens.ApiToken
  alias Client.ApiTokens.Query

  def new_changeset do
    ApiToken.changeset(%ApiToken{})
  end

  def get(token_id) do
    Client.Repo.get(ApiToken, token_id)
  end

  def get_by_description(user_id, description) do
    ApiToken
    |> Query.by_user_id(user_id)
    |> Query.by_description(description)
    |> Client.Repo.one()
  end

  def list(user_id) do
    ApiToken
    |> Query.by_user_id(user_id)
    |> Client.Repo.all()
  end

  def create(params) do
    %ApiToken{}
    |> ApiToken.changeset(params)
    |> Client.Repo.insert()
  end

  def delete(token_id) do
    token_id |> get() |> Client.Repo.delete()
  end
end
