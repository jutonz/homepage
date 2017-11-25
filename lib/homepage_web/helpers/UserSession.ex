defmodule HomepageWeb.Helpers.UserSession do
  import Plug.Conn
  import Comeonin.Argon2, only: [check_pass: 2]
  alias Homepage.User
  alias Homepage.Repo
  alias Homepage.Servers.SessionServer

  @doc """
  Generate an access token for a user given his or her username and password.
  This token can be passed in the Authorization header to make authenticated
  API calls.

  Returns {:ok, %{token: token}} on success, or {:error, reason} on failure.
  """
  def login_jwt(email, password) do
    case User |> Repo.get_by(email: email) |> check_pass(password) do
      {:ok, user} ->
        # Create a generic "access token".
        # TODO potentially look into using per-resource claims
        {:ok, jwt, _claims} = Homepage.GuardianSerializer.encode_and_sign(user, %{}, token_type: "access")
        {:ok, %{token: jwt}}
      _ -> {:error, "Invalid username or password"}
    end
  end

  @doc """
  Plug which prevents non-authenticated users from accessing authenticated
  routes.

  Returns conn
  """
  def load_user_or_redirect(conn, _options) do
    if SessionServer.current_user(conn) == nil do
      conn
        |> Phoenix.Controller.put_flash(:error, "Please login")
        |> Phoenix.Controller.redirect(to: "/login")
    end

    conn
  end
end
