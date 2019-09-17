defmodule Client.ApiTokens do
  alias Client.ApiToken
  alias Client.ApiTokens.Query

  def new_changeset do
    ApiToken.changeset(%ApiToken{})
  end

  def get(token_id) do
    Client.Repo.get(ApiToken, token_id)
  end

  def create(params) do
    %ApiToken{}
    |> ApiToken.changeset(params)
    |> Client.Repo.insert()
  end

  def delete(token_id) do
    token_id |> get() |> Client.Repo.delete()
  end

  def list_by_user_id(user_id) do
    ApiToken
    |> Query.by_user_id(user_id)
    |> Client.Repo.all()
  end
end
