defmodule Client.Session do
  import Plug.Conn
  alias Client.{User, Repo, UserServer}

  def login(conn, email, password) do
    with {:ok, user} <- UserServer.get_by_email(email),
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
    with {:ok, user, claims} <- Auth.resource_for_single_use_jwt(token),
         {:ok, conn} <- init_user_session(conn, user),
         {:ok, _resp} <- Auth.revoke_single_use_token(claims["jti"]),
         do: {:ok, user, conn},
         else:
           (
             {:error, reason} -> {:error, reason}
             _ -> {:error, "Failed to login"}
           )
  end

  def signup(conn, email, password) do
    changeset = User.changeset(%User{}, %{email: email, password: password})

    case Repo.insert(changeset) do
      {:ok, user} ->
        {:ok, conn} = init_user_session(conn, user)
        {:ok, user, conn}

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
      |> put_session(:user_id, nil)
      |> assign(:current_user, nil)

    {:ok, conn}
  end

  def current_user(conn) do
    case conn.assigns[:current_user] || load_current_user(conn) do
      %User{} = user -> {:ok, user}
      _ -> {:error, "Unauthenticated"}
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

  defp load_current_user(conn) do
    user_id = conn |> get_session(:user_id)

    if user_id do
      User |> Repo.get(user_id)
    end
  end
end
