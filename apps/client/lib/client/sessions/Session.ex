defmodule Client.Session do
  import Plug.Conn
  alias Client.{Auth, User, Repo}

  def login(conn, email, password) do
    with {:ok, user} <- User.get_by_email(email),
         {:ok, _pass} <- Auth.check_password(password, user.password_hash),
         {:ok, conn} <- init_user_session(conn, user),
         do: {:ok, user, conn},
         else:
           (
             {:error, reason} -> {:error, reason}
             _ -> {:error, "Failed to login"}
           )
  end

  def exchange(conn, token) do
    with {:ok, user_id, claims} <- Auth.resource_for_single_use_jwt(token),
         %User{} = user <- Repo.get(User, user_id),
         {:ok, conn} <- init_user_session(conn, user),
         {:ok, _resp} <- Auth.revoke_single_use_token(claims["jti"]),
         do: {:ok, user, conn},
         else:
           (
             {:error, reason} -> {:error, reason}
             _ -> {:error, "Failed to login"}
           )
  end

  def signup(email, password) do
    changeset = User.changeset(%User{}, %{email: email, password: password})

    case Repo.insert(changeset) do
      {:ok, user} ->
        {:ok, user}

      {:error, result} ->
        errors =
          Keyword.keys(result.errors)
          |> Enum.map(fn key ->
            message = result.errors[key] |> elem(0)
            to_string(key) <> " " <> message
          end)
          |> Enum.join(", ")

        {:error, errors}
    end
  end

  def logout(conn) do
    conn =
      conn
      |> clear_session()
      |> configure_session(drop: true)

    {:ok, conn}
  end

  def current_user(conn) do
    case conn.assigns[:current_user] || load_current_user(conn) do
      %User{} = user -> {:ok, user}
      _ -> {:error, "Unauthenticated"}
    end
  end

  def check_session(conn) do
    case get_session(conn, :user_id) do
      nil -> {:error, "Unauthenticated"}
      user_id -> {:ok, user_id}
    end
  end

  @doc """
  Create an authenticated session for the given user. The user will be from
  this point on able to make authenticated API calls using this session.

  Returns conn (now with session info)
  """
  def init_user_session(conn, user) do
    conn =
      conn
      |> assign(:current_user, user)
      |> put_session(:user_id, user.id)
      |> configure_session(renew: true)

    {:ok, conn}
  end

  def current_user_id(conn),
    do: get_session(conn, :user_id)

  def init_session_from_jwt(conn, _blueprint) do
    conn = Plug.Conn.fetch_session(conn)

    case current_user_id(conn) do
      nil ->
        jwt = auth_bearer_value(conn)

        case Client.Auth.resource_for_jwt(jwt) do
          {:ok, %{"id" => id}, _claims} ->
            user = %Client.User{id: id}
            {:ok, conn} = init_user_session(conn, user)
            conn

          _ ->
            conn
        end

      _ ->
        # session already established
        conn
    end
  end

  defp auth_bearer_value(conn) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> value] -> value
      _ -> nil
    end
  end

  defp load_current_user(conn) do
    case current_user_id(conn) do
      nil -> nil
      user_id -> Repo.get(User, user_id)
    end
  end
end
