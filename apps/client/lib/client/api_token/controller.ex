defmodule Client.ApiToken.Controller do
  alias Client.ApiToken
  alias Client.ApiToken.Query

  def list_by_user_id(user_id) do
    ApiToken
    |> Query.by_user_id(user_id)
    |> Client.Repo.all()
  end
end
