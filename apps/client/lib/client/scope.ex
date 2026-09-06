defmodule Client.Scope do
  @moduledoc """
  The caller on whose behalf a request runs.

  A scope is built once, wherever identity is established — an authenticated
  browser request, an API-token request, a socket connection, a routed
  LiveView mount — and is then handed to the domain contexts. Contexts ask the
  scope who the user is; they never take a raw user id from the caller.

  It deliberately carries only the user. Nothing in the domain varies by *how*
  you authenticated, so the scope records no token, no provenance, no request
  metadata. Add a field when something actually reads it.
  """

  alias Client.{Repo, User}

  @type t :: %__MODULE__{user: User.t()}

  @enforce_keys [:user]
  defstruct [:user]

  @doc """
  Builds a scope for an already-loaded user.
  """
  @spec for_user(User.t()) :: t()
  def for_user(%User{} = user), do: %__MODULE__{user: user}

  @doc """
  Builds a scope for a user id, loading the user.

  Returns `nil` when there is no such user — a session naming a deleted user
  is not authenticated.
  """
  @spec for_user_id(integer() | String.t() | nil) :: t() | nil
  def for_user_id(nil), do: nil

  def for_user_id(user_id) do
    case Repo.get(User, user_id) do
      %User{} = user -> for_user(user)
      nil -> nil
    end
  end
end
