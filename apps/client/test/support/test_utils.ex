defmodule Client.TestUtils do
  alias Client.{Repo, User, Session}

  @spec setup_current_user(Plug.Conn.t()) :: Plug.Conn.t()
  def setup_current_user(conn) do
    with user <- create_user(),
         conn <- conn |> Plug.Test.init_test_session(%{}),
         {:ok, conn} <- conn |> Session.init_user_session(user),
         do: conn
  end

  @spec create_user(map) :: User.t()
  def create_user(args \\ %{email: "me@mail.com", password: "password123"}) do
    %User{} |> User.changeset(args) |> Repo.insert!()
  end
end
