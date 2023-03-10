defmodule ClientWeb.Live.LiveHelpers do
  def allow_ecto_sandbox(socket) do
    %{assigns: %{phoenix_ecto_sandbox: metadata}} =
      Phoenix.Component.assign_new(socket, :phoenix_ecto_sandbox, fn ->
        if Phoenix.LiveView.connected?(socket) do
          Phoenix.LiveView.get_connect_info(socket, :user_agent)
        end
      end)

    Phoenix.Ecto.SQL.Sandbox.allow(metadata, ClientWeb.Plugs.Sandbox)
  end
end
