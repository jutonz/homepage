defmodule Auth do
  @moduledoc """
  Wrapper for Guardian and Comeonin dependencies. Anything related to passwords
  or JWT's should live here.
  """

  alias Auth.Guardian

  def hash_password(password) do
    {:ok, Comeonin.Argon2.hashpwsalt(password)}
  end

  def check_password(password, hash) do
    case Comeonin.Argon2.checkpw(password, hash) do
      true -> {:ok, password}
      _ -> {:error, "Invalid password"}
    end
  end

  @doc """
  Generate a JWT which can be exchanged exactly once in the given timeframe
  (default 24 hours).

  When later exchanging the token for a resource, be sure to use
  +resource_for_single_use_jwt+ to ensure the token is only exchanged once and
  then, after performing business whatever business logic necessary,
  +revoke_single_use_token+ to expire it.
  """
  def single_use_jwt(resource_id, ttl_sec \\ 86400) do
    with {:ok, token, claims} <-
           Guardian.encode_and_sign(
             resource_id,
             %{},
             token_type: "single-use",
             token_ttl: {ttl_sec, :seconds}
           ),
         {:ok, _resp} <-
           Redis.command(["setex", "single-use-token:#{claims["jti"]}", ttl_sec, true]),
         do: {:ok, token, claims},
         else:
           (
             {:error, reason} -> {:error, reason}
             _ -> {:error, "Failed to generate JWT"}
           )
  end

  def jwt_for_resource(resource_id) do
    Guardian.encode_and_sign(resource_id)
  end

  def resource_for_jwt(jwt) do
    Guardian.resource_from_token(jwt)
  end

  @doc """
  Same as +resouce_for_jwt+, but also checks that the provided token was not
  already expired via +expire_single_use_token+
  """
  def resource_for_single_use_jwt(jwt) do
    with {:ok, resource, claims} <- resource_for_jwt(jwt),
         {:ok, true} <- ensure_token_unrevoked(claims["jti"]),
         do: {:ok, resource, claims},
         else:
           (
             {:error, reason} -> {:error, reason}
             _ -> {:error, "Failed to exchange single use JWT"}
           )
  end

  defp ensure_token_unrevoked(jti) do
    with {:ok, "true"} <- Redis.command(["GET", "single-use-token:#{jti}"]),
         do: {:ok, true},
         else: (_ -> {:error, false})
  end

  @doc """
  Ensure that the provided JWT cannot be exchanged again.

  The provided jti argument can be found in the JWT's claims and represents a
  unique indentifier for the JWT (this is more efficient than storing the
  entire encoded token in redis).
  """
  def revoke_single_use_token(jti) do
    Redis.command(["del", "single-use-token:#{jti}"])
  end
end
