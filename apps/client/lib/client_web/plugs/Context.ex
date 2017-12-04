defmodule ClientWeb.Plugs.Context do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    context = conn |> build_current_user_context
    conn |> put_private(:absinthe, %{ context: context })
  end

  def build_current_user_context(conn) do
    case conn |> fetch_session |> resource_from_conn do
      {:ok, user} -> %{ current_user: user }
      _ -> %{}
    end
  end

  defp resource_from_conn(conn) do
    case conn |> Client.SessionServer.current_user do
      {:ok, user} -> {:ok, user}
      {:error, reason} -> {:error, reason}
    end
  end
end
