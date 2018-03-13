defmodule Client.TestUtils do
  alias Client.{Repo,User,SessionServer}

  def setup_current_user(conn) do
    with user_params <- %{email: "me@mail.com", password: "password123"},
         user <- %User{} |> User.changeset(user_params) |> Repo.insert!,
         conn <- conn |> Plug.Test.init_test_session(%{}),
         {:ok, conn } <- conn |> SessionServer.init_user_session(user),
    do: conn
  end
end
