defmodule HomepageWeb.Plugs.Context do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    context = conn |> build_current_user_context
    conn |> put_private(:absinthe, %{context: context})
  end

  defp build_current_user_context(conn) do
    case conn |> resource_from_conn do
      {:ok, user} -> %{current_user: user}
      _ -> %{}
    end
  end

  defp resource_from_conn(conn) do
    with {:ok, token} <- conn |> token_from_conn,
         {:ok, resource, _claims} <- token |> Homepage.GuardianSerializer.resource_from_token,
      do: {:ok, resource},
      else: ({:error, reason} -> {:error, reason})
  end

  defp token_from_conn(conn) do
    case conn |> get_req_header("authorization") do
      "Bearer " <> token -> {:ok, token}
      _ -> {:error, "Could not find Bearer token in Authorization header"}
    end
  end
end
