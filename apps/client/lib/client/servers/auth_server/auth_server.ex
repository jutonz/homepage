defmodule Client.AuthServer do
  @moduledoc """
  Server responsible for password and JWT creation and validation.

  Essentially a wrapper for Guardian and Comeonin dependencies; anything
  releated to passwords or JWT's should live here.
  """
  use GenServer

  alias Client.AuthServer.Guardian

  # Client API

  def start_link(opts \\ []) do
    {:ok, _pid} = GenServer.start_link(__MODULE__, [], opts)
  end

  def check_password(password, hash) do
    GenServer.call(:auth_server, {:check_password, password, hash})
  end

  def hash_password(password) do
    GenServer.call(:auth_server, {:hash_password, password})
  end

  def generate_login_link(user_id) do
    GenServer.call(:auth_server, {:generate_login_link, user_id})
  end

  @doc """
  Generate a JWT which can be exchanged exactly once in the next 24 hours.

  When later exchanging the token for a resource, be sure to use
  +resource_for_single_use_jwt+ to ensure the token is only exchanged once and
  then, after performing business whatever business logic necessary,
  +revoke_single_use_token+ to expire it.
  """
  def single_use_jwt(resource_id, ttl_sec \\ 86400) do
    with {:ok, token, claims} <- Guardian.encode_and_sign(resource_id, %{},
            token_type: "single-use",
            token_ttl: {ttl_sec, :seconds}
          ),
         {:ok, _resp} <- Client.Redis.command(
           ["setex", "single-use-token:#{claims["jti"]}", ttl_sec, true]
         ),
      do: {:ok, token, claims},
      else: (
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
      else: (
        {:error, reason} -> {:error, reason}
        _ -> {:error, "Failed to exchange single use JWT"}
      )
  end

  defp ensure_token_unrevoked(jti) do
    with {:ok, "true"} <- Client.Redis.command(["GET", "single-use-token:#{jti}"]),
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
    Client.Redis.command(["del", "single-use-token:#{jti}"])
  end

  # Server API

  def handle_call({:check_password, password, hash}, _from, state) do
    case Comeonin.Argon2.checkpw(password, hash) do
      true -> {:reply, {:ok, password}, state}
      _ -> {:reply, {:error, "Invalid password"}, state}
    end
  end

  def handle_call({:hash_password, password}, _from, state) do
    {:reply, {:ok, Comeonin.Argon2.hashpwsalt(password)}, state}
  end

  def handle_call({:generate_login_link, user_id}, _from, state) do
    with {:ok, token, _claims} <- single_use_jwt(user_id),
         url <- "#{ClientWeb.Endpoint.url}/login?token=#{token}",
      do: {:reply, {:ok, url}, state},
      else: (_ -> {:reply, {:error, "Couldn't authenticate"}, state})
  end
end
