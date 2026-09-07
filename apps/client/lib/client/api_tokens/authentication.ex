defmodule Client.ApiTokens.Authentication do
  @moduledoc """
  Turns a bare API token value into the identity it stands for.

  This is the one API token read that takes no `Client.Scope`, and it lives
  apart from `Client.ApiTokens` for exactly that reason. It runs at an entry
  point, before any identity exists: the request carries a token string and
  nothing else, and there is no user yet to scope the lookup to. Scoping it
  would be circular — the lookup is what establishes the scope.

  Keeping it in its own module makes "unscoped" a property of the module rather
  than of one function sitting among scoped siblings, where a reader has to
  notice which is which. Anything added here answers the same question: who is
  this caller? Everything a caller then does with their tokens belongs next
  door, where it takes a scope.
  """

  alias Client.ApiTokens.ApiToken
  alias Client.ApiTokens.Query
  alias Client.Repo
  alias Client.Scope

  @doc """
  Resolves a token value to the token row and a scope for its user.

  Answers `:error` when no such token exists, and equally when the token names
  a user who has since been deleted: a credential pointing at nobody
  authenticates nobody.
  """
  @spec authenticate(term()) :: {:ok, ApiToken.t(), Scope.t()} | :error
  def authenticate(token) when is_binary(token) do
    with %ApiToken{} = api_token <- get_by_token(token),
         %Scope{} = scope <- Scope.for_user_id(api_token.user_id) do
      {:ok, api_token, scope}
    else
      nil -> :error
    end
  end

  def authenticate(_token), do: :error

  defp get_by_token(token),
    do: ApiToken |> Query.by_token(token) |> Repo.one()
end
