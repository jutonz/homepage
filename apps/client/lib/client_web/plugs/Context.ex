defmodule ClientWeb.Plugs.Context do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    context = conn |> build_current_user_context
    conn |> put_private(:absinthe, %{context: context})
  end

  def build_current_user_context(conn) do
    user = user_from_jwt(conn) || user_from_session(conn)

    if user do
      %{current_user: user}
    else
      %{}
    end
  end

  def user_from_jwt(conn) do
    with [header] <- get_req_header(conn, "authorization"),
         "Bearer " <> token <- header,
         {:ok, %{"email" => email}, _claims} <- Client.Auth.resource_for_jwt(token),
         {:ok, user} <- Client.User.get_by_email(email),
         do: user,
         else: (_ -> nil)
  end

  defp user_from_session(conn) do
    case conn |> fetch_session |> resource_from_conn do
      {:ok, user} -> user
      _ -> nil
    end
  end

  defp resource_from_conn(conn) do
    case conn |> Client.Session.current_user() do
      {:ok, user} -> {:ok, user}
      {:error, reason} -> {:error, reason}
    end
  end
end
