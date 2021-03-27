defmodule Client.TestUtils do
  alias Client.{Factory, Session}

  @spec setup_current_user(Plug.Conn.t()) :: Plug.Conn.t()
  def setup_current_user(conn) do
    with user <- Factory.insert(:user),
         conn <- conn |> Plug.Test.init_test_session(%{}),
         {:ok, conn} <- conn |> Session.init_user_session(user),
         do: conn
  end
end
